class Person < ActiveRecord::Base

	has_many :measurements, :order => :measured_at, :dependent => :destroy
	has_many :person_graphs, :dependent => :destroy
	has_many :person_stats, :dependent => :destroy, :order => :position
	has_many :stats, :through => :person_stats
	belongs_to :user

	def unused_stats
		user.stats.reject {|stat| stats.include? stat}
	end

	def table(range=since_days_ago(10))
		table = measurements.in_range(range).group_by(&:day)
		map, units = stats_mapping
		table.each do |day,measurements|
			row = Array.new(stats.size) {[]}
			measurements.each do |measurement|
				index = measurement.stat.id
				value = measurement.in(units[index])
				row[map[index]] << value
			end
			table[day] = row
		end
	end

private

	def stats_mapping
		map, units = {}, {}
		person_stats.each do |pstat|
			map[pstat.stat.id] = pstat.position - 1
			units[pstat.stat.id] = pstat.unit
		end
		[map, units]
	end

	def since_days_ago(num)
		num.days.ago.to_date .. Date.today
	end

end
