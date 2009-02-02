class RenameUserIdToPersonId < ActiveRecord::Migration
  def self.up
		rename_column :stats, :user_id, :person_id
		rename_column :graphs, :user_id, :person_id
  end

  def self.down
		rename_column :stats, :person_id, :user_id
		rename_column :graphs, :person_id, :user_id
  end
end
