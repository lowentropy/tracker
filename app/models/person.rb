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
		map = stats_map
		table = measurements.in_range(range).group_by(&:day)
		table.each do |day,measurements|
			row = Array.new(stats.size) {[]}
			measurements.each do |measurement|
				row[map[measurement.stat.id]] << measurement
			end
			table[day] = row
		end
	end

private

	def stats_map
		returning(map = {}) do
			person_stats.each do |pstat|
				map[pstat.stat.id] = pstat.position - 1
			end
		end
	end

	def since_days_ago(num)
		num.days.ago.to_date .. Date.today
	end

end
