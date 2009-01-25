class AddMeasuredAtToMeasurements < ActiveRecord::Migration
  def self.up
		add_column :measurements, :measured_at, :datetime
  end

  def self.down
		remove_column :measurements, :measured_at
  end
end
