class CreatePersonGraphs < ActiveRecord::Migration
  def self.up
    create_table :person_graphs do |t|
      t.integer :person_id
      t.integer :graph_id
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :person_graphs
  end
end
