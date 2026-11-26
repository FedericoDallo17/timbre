class RefreshListingAvailabilityJob < ActiveJob::Base
  queue_as :default

  def perform
    Scraping::RefreshListingAvailability.new.call
  end
end
