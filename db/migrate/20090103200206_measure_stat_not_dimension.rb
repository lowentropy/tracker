class MeasureStatNotDimension < ActiveRecord::Migration
  def self.up
		rename_column :measurements, :dimension_id, :stat_id
  end

  def self.down
		rename_column :measurements, :stat_id, :dimension_id
  end
end
