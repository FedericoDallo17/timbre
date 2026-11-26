require "net/http"

module Scraping
  class RefreshListingAvailability
    SOURCE_URLS = {
      "info_casas_api" => Sources::InfoCasasApiAdapter::FRONTEND_BASE_URL,
      "housi" => Sources::HousiAdapter::FRONTEND_BASE_URL,
      "imperium_inmobiliaria" => Sources::ImperiumInmobiliariaAdapter::FRONTEND_BASE_URL,
      "remax" => Sources::RemaxAdapter::FRONTEND_BASE_URL
    }.freeze
    PER_SOURCE_LIMIT = 12
    CHECK_INTERVAL = 12.hours

    def call
      ListingSource.where(active: true, adapter_key: SOURCE_URLS.keys).find_each do |source|
        host = URI.parse(SOURCE_URLS.fetch(source.adapter_key)).host
        tracker = Sources::ThirdPartyCallTracker.new(listing_source: source)
        remax = if source.adapter_key == "remax"
          Sources::RemaxAdapter.new(on_request: tracker)
        end
        candidates(source).each do |listing|
          status = availability(listing.canonical_url, host:, tracker:, remax:)
          record_check(listing, status)
        end
      end
    end

    private

    def candidates(source)
      checked_at = Listing.arel_table[:availability_checked_at]
      source.listings.in_scope_inventory
        .where(checked_at.eq(nil).or(checked_at.lt(Time.current - CHECK_INTERVAL)))
        .order(checked_at.asc.nulls_first, :id)
        .limit(PER_SOURCE_LIMIT)
    end

    def availability(canonical_url, host:, tracker:, remax:)
      uri = URI.parse(canonical_url)
      return unless uri.is_a?(URI::HTTPS) && uri.host == host && uri.port == 443 && !uri.userinfo && uri.path.present? && uri.path != "/"

      if remax
        remax.availability_for_url(canonical_url)
      else
        public_page_availability(uri, tracker:)
      end
    rescue JSON::ParserError, URI::InvalidURIError, IOError, SystemCallError, Timeout::Error, SocketError, OpenSSL::SSL::SSLError, Net::ProtocolError => error
      Rails.logger.warn("[RefreshListingAvailability] #{host}: #{error.class}")
      nil
    end

    def record_check(listing, status)
      now = Time.current
      updates = { availability_checked_at: now }
      updates[:unavailable_at] = listing.unavailable_at || now if status == :unavailable
      updates[:unavailable_at] = nil if status == :available
      Listing.where(id: listing.id, canonical_url: listing.canonical_url, availability_checked_at: listing.availability_checked_at).update_all(updates)
    end

    def public_page_availability(uri, tracker:)
      tracker.call
      Net::HTTP.start(uri.host, uri.port, use_ssl: true, open_timeout: 3, read_timeout: 5, max_retries: 0) do |http|
        http.request_get(uri.request_uri, { "User-Agent" => Sources::HousiAdapter::HEADERS.fetch("user-agent") }) do |response|
          return :unavailable if response.is_a?(Net::HTTPNotFound) || response.is_a?(Net::HTTPGone)
          return :available if response.is_a?(Net::HTTPOK)
          return nil
        end
      end
    end
  end
end
