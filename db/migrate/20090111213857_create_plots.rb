class CreatePlots < ActiveRecord::Migration
  def self.up
    create_table :plots do |t|
      t.string :name
      t.integer :stat_id
      t.integer :graph_id
      t.string :color
      t.string :style
      t.boolean :smooth

      t.timestamps
    end
  end

  def self.down
    drop_table :plots
  end
end
