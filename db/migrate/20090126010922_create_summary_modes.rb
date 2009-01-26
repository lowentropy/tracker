class CreateSummaryModes < ActiveRecord::Migration
  def self.up
    create_table :summary_modes do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :summary_modes
  end
end
