class DateTable

	attr_reader :person
	attr_reader :range

	def initialize(person, range, include_all=false)
		@range = range
		@person = person
		@stats = person.stats
		@stats = @stats.visible unless include_all
		@data = @stats.map do |stat|
			stat.measurements.inside(range)
		end
		@weekly = {}
		@daily = {}
	end
	
	# iterate all stat measurements in parallel, collecting them by day
	# and ordering by the time of measurement. yields the date and
	# an array of measurement lists to the provided block. the array
	# follows the order of (visible) stats from the source Person. the
	# returned data ranges over the available dates in the measurements.
	def each_row(&block)
		# get the table of measurements grouped by day
		return if @data.empty?
		table = @data.map do |measurements|
			measurements.group_by(&:day).to_a.reverse
		end
		# loop through each next day at the top of the list
		while true
			top = table.map do |col|
				col.any? ? col[0][0] : ''
			end
			break if (date = top.max).empty?
			entries = table.map do |col|
				if col.any? and col[0][0] == date
					col.shift[1]
				else
					[]
				end
			end
			yield date, entries
		end
	end

	# iterate through each week of data for the given stat,
	# yielding the first day, last day, and array of daily values
	# and summaries for each day of that week.
	def each_week_of(stat_or_name, &block)
		weekly(stat_or_name).each do |first,days|
			yield first, (first + 6.days), days
		end
	end

	# iterate through each day of data for the given stat,
	# yielding the day and an array of daily values and summaries.
	def each_day_of(stat_or_name, &block)
		daily(stat_or_name).each &block
	end

	# return a raw array of summarized values for each day in the
	# range, including missing data as nil
	def daily_values(stat_or_name)
		stat, measurements = get_stat_data(stat_or_name)
		daily_summaries(stat, measurements, range).map {|entry| entry[1][0]}
	end

	# return number of weeks in weekly range
	def num_weeks
		last = range.end.end_of_week
		first = range.begin.beginning_of_week
		((last - first).to_i + 1) / 7
	end

	# return number of days in daily range
	def num_days
		(range.end - range.begin).to_i + 1
	end

private

	# get measurements of a particular stat
	def measurements_of(stat_or_name)
		stats = person.stats.visible
		stat = person.stat(stat_or_name)
		self[stats.index(stat)]
	end

	# get or construct the weekly summary view of a stat
	def weekly(stat_or_name)
		stat, measurements = get_stat_data(stat_or_name)
		@weekly[stat.id] ||= weekify(stat, measurements)
	end

	def get_stat_data(stat_or_name)
		stat = person.stat(stat_or_name)
		measurements = @data[@stats.index(stat)]
		[stat, measurements]
	end

	# get or construct the daily summary view of a stat
	def daily(stat_or_name)
		stat, measurements = get_stat_data(stat_or_name)
		@daily[stat.id] ||= dayify(stat, measurements)
	end

	# returns a two-dimensional array of daily summary of a SINGLE stat.
	# the beginning and ending of the first and last weeks, as well as
	# missing entries, are included. the weeks are given over the range
	# passed to the constructor, regardless of whether data is available
	# in parts of that range.
	def weekify(stat, measurements)
		days = daily_summaries(stat, measurements, week_range)
		weeks = days.in_groups_of(7).map do |week|
			[week[0][0], week.map {|d| d[1]}]
		end
		ActiveSupport::OrderedHash.new(weeks)
	end

	# returns a one-dimensional array of daily summary of a SINGLE stat.
	# missing entries are included. the returned data is given over the
	# range passed to the constructor, regardless of whether data is
	# available in parts of that range.
	def dayify(stat, measurements)
		days = daily_summaries(stat, measurements, range)
		ActiveSupport::OrderedHash.new(days)
	end

	# return an expanded range that includes the beginning of the first
	# week and end of the last week
	def week_range
		first = range.begin.beginning_of_week
		final = range.end.end_of_week
		first..final
	end
	
	# return daily summaries in an array of the form
	# [date, [summary, *measurements]]
	def daily_summaries(stat, measurements, range)
		last, days = range.begin, []
		measurements.group_by(&:date).each do |date,meas|
			(last...date).each {|day| days << [day, [nil]]}
			days << [date, [stat.summarize(meas), *meas]]
			last = date.tomorrow
		end
		(last..range.end).each {|day| days << [day, [nil]]}
		days
	end

end
