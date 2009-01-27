class Person < ActiveRecord::Base

	has_many :person_graphs, :dependent => :destroy
	has_many :person_stats, :dependent => :destroy,
													:order => :position, :include => :stat
	has_many :measurements, :through => :person_stats, :order => :measured_at
	has_many :stats, :through => :person_stats, :order => 'person_stats.position'
	belongs_to :user

	def stat(stat_or_name)
		if stat_or_name.is_a? Stat
			person_stats.find_by_stat_id stat_or_name.id 
		else
			person_stats.find :first, :joins => :stat,
				:conditions => ["stats.name = ?", stat_or_name]
		end
	end

	def unused_stats
		user.stats.reject {|stat| stats.include? stat}
	end

	def table(range=since_days_ago(10))
		person_stats.visible.map do |stat|
			stat.measurements.inside(range).group_by(&:day)
		end.extend DateTable
	end

	def measure(stat, time, value, unit=nil)
		stat = self.stat(stat) unless stat.is_a? PersonStat
		value = Unit.normalize(value, unit || stat.unit)
		stat.measurements.create :measured_at => time, :value => value
	end

private

	def since_days_ago(num)
		num.days.ago.to_date .. Date.today
	end

end
