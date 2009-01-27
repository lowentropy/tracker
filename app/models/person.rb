class Person < ActiveRecord::Base

	has_many :measurements, :order => :measured_at, :dependent => :destroy
	has_many :person_graphs, :dependent => :destroy
	has_many :person_stats, :dependent => :destroy,
													:order => :position, :include => :stat
	has_many :stats, :through => :person_stats, :order => 'person_stats.position'
	belongs_to :user

	def visible_stats
		person_stats.visible.map {|ps| ps.stat}
	end

	def unused_stats
		user.stats.reject {|stat| stats.include? stat}
	end

	def table(range=since_days_ago(10))
		map = stats_map
		table = measurements.of(visible_stats).inside(range).group_by(&:day)
		table.each do |day,measurements|
			row = Array.new(person_stats.visible.size) {[]}
			measurements.each do |measurement|
				row[map[measurement.stat.id]] << measurement
			end
			table[day] = row
		end
	end

	def measure(stat, time, value)
		stat = Stat.find_by_name(stat) unless stat.is_a? Stat
		value = Unit.parse(value) if value =~ /[^0-9]/
		measurements.create(
			:stat_id => stat.id,
			:measured_at => time,
			:value => value)
	end

private

	def stats_map
		returning(map = {}) do
			person_stats.visible.each do |pstat|
				map[pstat.stat.id] = pstat.position - 1
			end
		end
	end

	def since_days_ago(num)
		num.days.ago.to_date .. Date.today
	end

end
