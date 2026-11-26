require "test_helper"

class Scraping::RefreshListingAvailabilityTest < ActiveSupport::TestCase
  test "hides removed listings from saved searches and restores them after a successful check" do
    source = ListingSource.create!(name: "InfoCasas", adapter_key: "info_casas_api", active: true)
    listing = source.listings.create!(title: "Apartamento", canonical_url: "https://www.infocasas.com.uy/apartamento/123", location_text: "Pocitos", in_scope: true)
    search = create_push_test_user!.search_preferences.create!(name: "Pocitos", location_query: "Pocitos")
    service = Scraping::RefreshListingAvailability.new
    updated_at = listing.updated_at

    with_response(Net::HTTPNotFound) { service.call }
    assert listing.reload.unavailable_at.present?
    assert_equal updated_at, listing.updated_at
    assert_not_includes Listing.for_search_feed(search), listing

    travel 13.hours do
      with_response(Net::HTTPServiceUnavailable) { service.call }
      assert listing.reload.unavailable_at.present?
    end

    travel 26.hours do
      with_response(Net::HTTPOK) { service.call }
      assert_nil listing.reload.unavailable_at
      assert_includes Listing.for_search_feed(search), listing
    end
  end

  test "leaves listings visible after redirects and does not request other hosts" do
    source = ListingSource.create!(name: "Housi", adapter_key: "housi", active: true)
    redirected = source.listings.create!(title: "Redirected", canonical_url: "https://www.housi.com.uy/propiedad/123", in_scope: true)
    foreign = source.listings.create!(title: "Foreign host", canonical_url: "https://example.test/propiedad/456", in_scope: true)
    service = Scraping::RefreshListingAvailability.new

    with_response(Net::HTTPFound) { service.call }

    assert_nil redirected.reload.unavailable_at
    assert_nil foreign.reload.unavailable_at
    assert_equal 1, source.reload.third_party_calls_count
  end

  private

  def with_response(response_class)
    original_start = Net::HTTP.method(:start)
    http = Object.new
    http.define_singleton_method(:request_get) do |_, _, &block|
      block.call(response_class.new("1.1", nil, nil))
    end
    Net::HTTP.define_singleton_method(:start) { |*, **, &block| block.call(http) }
    yield
  ensure
    Net::HTTP.define_singleton_method(:start, original_start)
  end
end
