class CreatePersonStats < ActiveRecord::Migration
  def self.up
    create_table :person_stats do |t|
      t.integer :person_id
      t.integer :stat_id
      t.integer :position
      t.integer :unit_id

      t.timestamps
    end
  end

  def self.down
    drop_table :person_stats
  end
end
