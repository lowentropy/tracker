class CreateStats < ActiveRecord::Migration
  def self.up
    create_table :stats do |t|
      t.integer :dimension_id
      t.string :name
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :stats
  end
end
