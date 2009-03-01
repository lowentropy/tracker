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

	def date
		adjusted_date(measured_at)
	end

	def hour
		measured_at.hour
	end

	def day(format="%Y-%m-%d")
		date.strftime(format)
	end

	def week(format="%Y-%m-%d")
		date.beginning_of_week.strftime(format)
	end

	def day_of_week
		d = date
		(d - d.beginning_of_week).to_i
	end

	def adjusted_date(datetime)
		(datetime - stat.person.day_begins_at.hour.hours).to_date
	end

	def adjusted_hour
		(hour - stat.person.day_begins_at.hour) % 24
	end

	def short_time
		measured_at.strftime('%l:%M%P')
	end

	def trim(value)
		"%.#{stat.decimal_places}f" % value
	end

	def denormalized(unit=stat.unit)
		unit.denormalize value
	end

	def in(unit)
		"#{trim(unit.denormalize(value))} #{unit.short_name}"
	end

	def display(unit=stat.unit)
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
