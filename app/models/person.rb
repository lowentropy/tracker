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
		measurements.in_range(range).group_by &:day
	end

private

	def since_days_ago(num)
		num.days.ago.to_date .. Date.today
	end

end
