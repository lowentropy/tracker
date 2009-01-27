class AddPersonStatIdToMeasurements < ActiveRecord::Migration
  def self.up
		add_column :measurements, :person_stat_id, :integer
  end

  def self.down
		remove_column :measurements, :person_stat_id
  end
end
