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
		{ :conditions => ["date(measured_at) BETWEEN ? AND ?",
				range.begin.to_date, range.end.to_date] }
	}

	def day
		measured_at.strftime('%Y-%m-%d')
	end

end
