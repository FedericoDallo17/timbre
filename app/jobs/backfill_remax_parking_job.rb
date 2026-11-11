class BackfillRemaxParkingJob < ActiveJob::Base
  queue_as :default
  limits_concurrency to: 1, key: ->(*) { "remax-parking" }, duration: 20.minutes

  def perform(limit: Scraping::BackfillRemaxParking::DEFAULT_LIMIT, external_ids: nil)
    result = Scraping::BackfillRemaxParking.new.call(limit:, external_ids:)
    Rails.logger.info("[BackfillRemaxParkingJob] seen=#{result.listings_seen_count} updated=#{result.listings_updated_count}")
    result
  end
end
