class ChangeEmailErrorsToStringError < ActiveRecord::Migration
  def self.up
		change_table :emails do |t|
			t.remove :errors
			t.string :error
		end
  end

  def self.down
		change_table :emails do |t|
			t.remove :error
			t.text :errors
		end
  end
end
