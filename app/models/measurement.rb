class Measurement < ActiveRecord::Base

	belongs_to :person
	belongs_to :stat

	named_scope :of, lambda {|stat|
		if stat.is_a? String
			{ :joins => :stat,
				:conditions => ["stats.name = ?", stat] }
		else
			{ :conditions => {:stat_id => stat} }
		end
	}

	named_scope :inside, lambda {|range|
		{ :conditions => ["date(measured_at) BETWEEN ? AND ?",
				range.begin.to_date, range.end.to_date] }
	}

	def day
		measured_at.strftime('%Y-%m-%d')
	end

	def short_time
		measured_at.strftime('%l%P')
	end

	def in(unit)
		"#{value * unit.multiplier} #{unit.short_name}"
	end

	def display(unit)
		"#{short_time}: #{self.in(unit)}"
	end

end
