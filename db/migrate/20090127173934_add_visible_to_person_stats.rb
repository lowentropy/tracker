class AddVisibleToPersonStats < ActiveRecord::Migration
  def self.up
		add_column :person_stats, :visible, :boolean, :default => true
  end

  def self.down
		remove_column :person_stats, :visible
  end
end
