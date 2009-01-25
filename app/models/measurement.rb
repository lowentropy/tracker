class Measurement < ActiveRecord::Base

	belongs_to :person
	belongs_to :stat

	named_scope :of, lambda {|stat|
		if stat.is_a? Stat
			puts "STAT: #{stat.id}"
			{ :conditions => {:stat_id => stat.id} }
		else
			puts "STAT NAME: #{stat}"
			{ :joins => :stat,
				:conditions => ["stats.name = ?", stat] }
		end
	}

	named_scope :in_range, lambda {|range|
		{ :conditions => {:measured_at => time_range(range)} }
	}

	def day
		measured_at.strftime('%Y-%m-%d')
	end

private

	def self.time_range(range)
		range.begin.class.is_a?(Date) ? range :
			(range.begin.beginning_of_day .. range.end.end_of_day)
	end

end
