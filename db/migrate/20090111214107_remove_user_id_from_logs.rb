class RemoveUserIdFromLogs < ActiveRecord::Migration
  def self.up
		remove_column :logs, :user_id
  end

  def self.down
		add_column :logs, :user_id, :integer
  end
end
