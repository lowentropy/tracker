class CreateGraphs < ActiveRecord::Migration
  def self.up
    create_table :graphs do |t|
      t.string :type
      t.integer :user_id
      t.string :title
      t.string :ylabel
      t.integer :width
      t.integer :height

      t.timestamps
    end
  end

  def self.down
    drop_table :graphs
  end
end
