class Measurement < ActiveRecord::Base

	belongs_to :stat

	named_scope :of, lambda {|stat|
		if stat.is_a? String
			{ :conditions => ["stats.name = ?", stat] }
		else
			{ :conditions => { :stat => stat } }
		end
	}

	named_scope :inside, lambda {|range|
		{ :conditions => {:measured_at => utc_bound(range)} }
	}

	def day
		adjusted_date(measured_at).strftime('%Y-%m-%d')
	end

	def adjusted_date(datetime)
		(datetime - stat.person.day_begins_at.hour.hours).to_date
	end

	def short_time
		measured_at.strftime('%l:%M%P')
	end

	def trim(value)
		"%.#{stat.decimal_places}f" % value
	end

	def in(unit)
		"#{trim(unit.denormalize(value))} #{unit.short_name}"
	end

	def display(unit)
		"#{short_time}: #{self.in(unit)}"
	end

private

	def self.utc_bound(range)
		a, b = range.begin.to_date, range.end.to_date
		a = a.beginning_of_day
		b = b.end_of_day
		(a.utc..b.utc)
	end

end
