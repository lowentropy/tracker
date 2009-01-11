class CreateMeasurements < ActiveRecord::Migration
  def self.up
    create_table :measurements do |t|
      t.float :value
      t.integer :dimension_id
      t.integer :person_id

      t.timestamps
    end
  end

  def self.down
    drop_table :measurements
  end
end
