class CreateLogs < ActiveRecord::Migration
  def self.up
    create_table :logs do |t|
      t.integer :user_id
      t.integer :measurement_id
      t.datetime :measured_at
      t.text :notes

      t.timestamps
    end
  end

  def self.down
    drop_table :logs
  end
end
