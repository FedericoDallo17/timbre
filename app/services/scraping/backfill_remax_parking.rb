module Scraping
  class BackfillRemaxParking
    DEFAULT_LIMIT = 50
    MAX_LIMIT = 100
    Result = Struct.new(:listings_seen_count, :listings_updated_count, keyword_init: true)

    def call(limit: DEFAULT_LIMIT, external_ids: nil, adapter: nil)
      limit = Integer(limit)
      raise ArgumentError, "limit must be between 1 and #{MAX_LIMIT}" unless (1..MAX_LIMIT).cover?(limit)

      source = ListingSource.find_by(adapter_key: "remax", active: true)
      return Result.new(listings_seen_count: 0, listings_updated_count: 0) unless source

      adapter ||= Sources::RemaxAdapter.new(on_request: Sources::ThirdPartyCallTracker.new(listing_source: source))
      relation = source.listings.where(parking_spaces: nil)
      relation = relation.where(external_id: Array(external_ids).map(&:to_s)) if external_ids
      seen = 0
      updated = 0

      relation.order(created_at: :desc, id: :desc).limit(limit).each do |listing|
        seen += 1
        count = adapter.parking_spaces_for_url(listing.canonical_url)
        next unless count.is_a?(Integer) && count >= 0

        Listing.transaction do
          # Do not change updated_at: enrichment is not a provider sighting and
          # must not extend the seven-day shared inventory retention window.
          changed = source.listings.where(id: listing.id, parking_spaces: nil).update_all(parking_spaces: count)
          next if changed.zero?

          ListingTrack.where(listing_id: listing.id)
            .where("snapshot ->> 'parking_spaces' IS NULL")
            .update_all(["snapshot = jsonb_set(snapshot, '{parking_spaces}', ?::jsonb, true)", count.to_json])
          updated += changed
        end
      end

      Result.new(listings_seen_count: seen, listings_updated_count: updated)
    end
  end
end
