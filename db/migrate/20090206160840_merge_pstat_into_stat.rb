class MergePstatIntoStat < ActiveRecord::Migration
  def self.up
		change_table :stats do |t|
			t.integer :position
			t.integer :unit_id
			t.integer :summary_mode_id
			t.boolean :visible
			t.integer :decimal_places
		end
		Person.all.each do |person|
			person.person_stats.each do |pstat|
				pstat.stat.update_attributes(
					:position => pstat.position,
					:unit_id => pstat.unit_id,
					:summary_mode_id => pstat.summary_mode_id,
					:visible => pstat.visible,
					:decimal_places => pstat.decimal_places)
			end
		end
  end

  def self.down
		change_table :stats do |t|
			t.remove :person_id, :position, :unit_id,
				:summary_mode_id, :visible, :decimal_places
		end
  end
end
