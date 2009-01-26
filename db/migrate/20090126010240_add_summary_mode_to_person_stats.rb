class AddSummaryModeToPersonStats < ActiveRecord::Migration
  def self.up
		add_column :person_stats, :summary_mode_id, :integer
  end

  def self.down
		remove_column :person_stats, :summary_mode_id
  end
end
