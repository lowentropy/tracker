class MoveMeasurementsUnderStat < ActiveRecord::Migration
  def self.up
		add_column :measurements, :stat_id, :integer
		#Measurement.all.each do |m|
		#	m.update_attributes :stat_id => m.person_stat.stat.id
		#end
		remove_column :measurements, :person_stat_id
  end

  def self.down
		#add_column :measurements, :person_stat_id, :integer
		#Measurement.all.each do |m|
		#	ps = PersonStat.find_by_person_id_and_stat_id(m.stat.person.id, m.stat.id)
		#	m.update_attributes :person_stat_id => ps.id
		#end
		remove_column :measurements, :stat_id
  end
end
