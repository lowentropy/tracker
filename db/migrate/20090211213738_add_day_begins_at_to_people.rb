class AddDayBeginsAtToPeople < ActiveRecord::Migration
  def self.up
  	add_column :people, :day_begins_at, :time, :default => Time.parse('6am')
  end

  def self.down
  	remove_column :people, :day_begins_at
  end
end
