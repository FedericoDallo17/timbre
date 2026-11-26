class AddListingAvailabilityChecks < ActiveRecord::Migration[8.0]
  def change
    add_column :listings, :availability_checked_at, :datetime
    add_column :listings, :unavailable_at, :datetime
  end
end
