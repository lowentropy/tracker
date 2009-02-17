class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.integer :person_id
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :groups
  end
end
