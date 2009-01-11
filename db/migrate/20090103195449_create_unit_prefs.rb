class CreateUnitPrefs < ActiveRecord::Migration
  def self.up
    create_table :unit_prefs do |t|
      t.integer :unit_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :unit_prefs
  end
end
