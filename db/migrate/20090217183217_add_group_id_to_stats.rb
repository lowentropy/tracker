class AddGroupIdToStats < ActiveRecord::Migration
  def self.up
		add_column :stats, :group_id, :integer
  end

  def self.down
		remove_column :stats, :group_id
  end
end
