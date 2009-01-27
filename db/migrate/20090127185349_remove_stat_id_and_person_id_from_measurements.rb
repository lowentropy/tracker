class RemoveStatIdAndPersonIdFromMeasurements < ActiveRecord::Migration
  def self.up
		remove_column :measurements, :stat_id
		remove_column :measurements, :person_id
  end

  def self.down
		add_column :measurements, :stat_id, :integer
		add_column :measurements, :person_id, :integer
  end
end
