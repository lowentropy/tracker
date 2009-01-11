class AddStatIdToUnitPref < ActiveRecord::Migration
  def self.up
		add_column :unit_prefs, :stat_id, :integer
  end

  def self.down
		remove_column :unit_prefs, :stat_id
  end
end
