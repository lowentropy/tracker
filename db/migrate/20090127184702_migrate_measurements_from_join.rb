class MigrateMeasurementsFromJoin < ActiveRecord::Migration
  def self.up
		Measurement.find(:all).each do |m|
			ps = PersonStat.find_by_person_id_and_stat_id m.person_id, m.stat_id
			m.update_attributes :person_stat_id => ps.id
		end
  end

  def self.down
		Measurement.find(:all, :joins => :person_stat).each do |m|
			m.update_attributes(
				:person_id => m.person_stat.person_id,
				:stat_id => m.person_stat.stat_id)
		end
  end
end
