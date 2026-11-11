require "test_helper"

class Scraping::BackfillRemaxParkingTest < ActiveSupport::TestCase
  test "fills explicit counts including zero without changing freshness and skips known counts" do
    source = ListingSource.create!(name: "Remax", adapter_key: "remax")
    first = listing(source, "first", updated_at: 3.days.ago)
    zero = listing(source, "zero")
    known = listing(source, "known", parking_spaces: 2)
    unknown = listing(source, "unknown")
    other = listing(ListingSource.create!(name: "Other", adapter_key: "mock_source"), "other")
    timestamp = first.updated_at
    requests = []
    result = Scraping::BackfillRemaxParking.new.call(adapter: adapter_for({ first.canonical_url => 1, zero.canonical_url => 0 }, requests))

    assert_equal 3, result.listings_seen_count
    assert_equal 2, result.listings_updated_count
    assert_equal 1, first.reload.parking_spaces
    assert_equal timestamp, first.updated_at
    assert_equal 0, zero.reload.parking_spaces
    assert_equal 2, known.reload.parking_spaces
    assert_nil unknown.reload.parking_spaces
    assert_nil other.reload.parking_spaces
    assert_not_includes requests, known.canonical_url
  end

  test "only fills missing snapshot parking and preserves personal tracking" do
    source = ListingSource.create!(name: "Remax", adapter_key: "remax")
    property = listing(source, "tracked")
    user = create_push_test_user!
    track = user.listing_tracks.build(favorite: true, contacted_on: Date.yesterday)
    track.capture_listing(property)
    track.save!
    snapshot = track.snapshot.deep_dup
    result = Scraping::BackfillRemaxParking.new.call(adapter: adapter_for({ property.canonical_url => 1 }, []))

    assert_equal 1, result.listings_updated_count
    assert_equal snapshot.merge("parking_spaces" => 1), track.reload.snapshot
    assert track.favorite
    assert_equal Date.yesterday, track.contacted_on
  end

  test "respects limits and explicit ids and does not run inactive sources" do
    source = ListingSource.create!(name: "Remax", adapter_key: "remax")
    first = listing(source, "first")
    second = listing(source, "second")
    adapter = adapter_for({ first.canonical_url => 1, second.canonical_url => 1 }, [])
    result = Scraping::BackfillRemaxParking.new.call(limit: 1, external_ids: [second.external_id], adapter: adapter)
    assert_equal 1, result.listings_updated_count
    assert_nil first.reload.parking_spaces
    assert_equal 1, second.reload.parking_spaces
    source.update!(active: false)
    assert_equal 0, Scraping::BackfillRemaxParking.new.call(adapter: adapter).listings_seen_count
    assert_raises(ArgumentError) { Scraping::BackfillRemaxParking.new.call(limit: 101) }
  end

  private

  def listing(source, slug, **attributes)
    Listing.create!({ listing_source: source, external_id: slug, title: slug,
      canonical_url: "https://www.remax.com.uy/listings/#{slug}" }.merge(attributes))
  end

  def adapter_for(counts, requests)
    Object.new.tap do |adapter|
      adapter.define_singleton_method(:parking_spaces_for_url) do |url|
        requests << url
        counts[url]
      end
    end
  end
end
