class AddOpenidAndTimezonToPeople < ActiveRecord::Migration
  def self.up
		change_table :people do |t|
			t.string :openid_url
			t.string :time_zone, :default => 'Central Time (US & Canada)'
		end
  end

  def self.down
		change_table :people do |t|
			t.remove :openid_url, :time_zone
		end
  end
end
