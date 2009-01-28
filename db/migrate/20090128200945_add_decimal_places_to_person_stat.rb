class AddDecimalPlacesToPersonStat < ActiveRecord::Migration
  def self.up
		add_column :person_stats, :decimal_places, :integer, :default => 0
  end

  def self.down
		remove_column :person_stats, :decimal_places
  end
end
