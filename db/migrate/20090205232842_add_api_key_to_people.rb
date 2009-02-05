class AddApiKeyToPeople < ActiveRecord::Migration
  def self.up
  	add_column :people, :api_key, :string
  end

  def self.down
  	remove_column :people, :api_key
  end
end
