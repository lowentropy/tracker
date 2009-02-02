class AddOpenidUrlToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :openid_url, :string
  end

  def self.down
    remove_column :people, :openid_url
  end
end
