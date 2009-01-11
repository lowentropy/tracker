class MakeStatsBelongToUser < ActiveRecord::Migration
  def self.up
		add_column :stats, :user_id, :integer
  end

  def self.down
		remove_column :stats, :user_id
  end
end
