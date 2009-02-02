class RemoveMostReferencesToUserId < ActiveRecord::Migration
  def self.up
		remove_column :people, :user_id
		#drop_table :users
		#drop_table :unit_prefs
  end

  def self.down
		add_column :people, :user_id, :integer
		#create_table 'users' do |t|
		#	t.string :login
		#	t.string :openid_url
		#	t.string :time_zone, :default => 'Central Time (US & Canada)'
		#	t.timestamps
		#end
		#create_table 'unit_prefs' do |t|
		#	t.integer :unit_id
		#	t.integer :user_id
		#	t.integer :stat_id
		#	t.timestamps
		#end
  end
end
