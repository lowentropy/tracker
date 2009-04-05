class Person < ActiveRecord::Base

	has_many :graphs, :dependent => :destroy
	has_many :stats, :dependent => :destroy, :order => :position
	has_many :groups, :dependent => :destroy, :order => :position
	has_many :measurements, :through => :stats, :order => 'measured_at'

	# look up the stat by a partial name
	def stat(stat_or_name)
		if stat_or_name.is_a? Stat
			stat_or_name
		else
			stats.find :first, :conditions =>
				["name LIKE ?", stat_or_name+'%']
		end
	end

	# default number of days to include in tables, graphs
	def default_range
		(measurements.first.date..Date.today)
	end

	# return the range of dates for which values of the given
	# stat were recorded
	def stat_range(stat_or_name)
		first = stat(stat_or_name).measurements.first
		(first.date..Date.today)
	end

	# return a table of measurements in the given range.
	# the returned table includes DateTable, allowing the
	# entries to be traversed in parallel.
	def table(range=default_range)
		DateTable.new(self, range)
	end

	# record a measurement on a particular statistic. the
	# unit of measurement can be overridden. both the stat and
	# unit parameters can be names or records.
	def measure(stat_or_name, time, value, unit=nil)
		stat = self.stat(stat_or_name)
		raise "unknown stat: #{stat_or_name}" unless stat
		value = Unit.normalize(value, unit || stat.unit, stat)
		stat.measurements.new :measured_at => time, :value => value
	end

	# quick-add. format: [<num> [<unit>]] <stat> [(at|@) <time>]
	def quick(sentence)

		# use the explicitly given date/time
		time = DateTime.now
		if i = sentence.index(/\s(at|@)\s/)
			text = sentence[sentence.index(' ', i+1)..-1].strip
			time = adjust_user_time text
			sentence = sentence[0...i].strip
		end

		# split into separate entries
		entries = sentence.split /[,;]/
		
		# map to measurements
		measurements = entries.map do |entry|
			# split into words
			words = entry.strip.split(/\s+/)

			# use the explicitly given numeric value
			# TODO: check if the user accidentally left out
			# the space between number and unit, e.g. 324mg
			value = 1.0
			if words[0].to_f != 0.0
				value = words.shift.to_f
				# modify the value with an explicitly given unit
				if words.size > 1
					value = "#{value} #{words.shift}"
				end
			end
			
			# throw out bad sentences
			throw "invalid entry: #{entry}" if words.size != 1

			# convert the entry into a measurement
			measure words[0], time, value
		end

		# save all measurements, or none
		measurements.each_with_index do |measurement,i|
			unless measurement.save
				measurements[0...i].each {|m| m.destroy}
				throw "failed to save entry: #{entries[i]}"
			end
		end
	end

	# turn user-entered time into actual time. straightforward use
	# of datetime except that if no explicit date is given, make sure
	# the time isn't in the future
	def adjust_user_time(text)
		return text unless Time.parse(text).future?
		Date.parse text
		text
	rescue
		"#{Date.yesterday.to_s} #{text}"
	end

	# user-configured first hour of the day, formatted as '6am'
	def first_hour
		day_begins_at.strftime '%l%P'
	end

	# set the first hour of the day; any valid time format
	def first_hour=(hour)
		self.day_begins_at = Time.parse(hour)
	end

	# render a ploticus graph of a stat, in the weekly view
	def plot_weekly(table, stat)
		opts = chart_weekly(table, stat)
		Ploticus.script(opts) do
			# set page title and size
			page do
				pagesize @width * 7, @height * @weeks
				title stat.name.capitalize
			end
			# get the data from the trailer
			getdata { _intrailer }
			# define how a cell looks
			_procdef :areadef do
				xrange -1, 24
				yrange 0, @max * 1.1
				box @width, @height
				_saveas :cell
			end
			# define how the bars should look
			_procdef :bars do
				color :red
				outline :no #:yes #:color => :white, :width => 1.0
				barsrange 0, 23
				barwidth @bars
				locfield 1
				lenfield 2
				_saveas :bars
			end
			# first, draw the overall grid TODO
			areadef do
				rectangle 0, 0, @width * 7, @height * @weeks
				xrange 0, 7
				yrange 0, @weeks
			end
			# draw x axis
			xaxis do
				stubslide -(@width / 2)
				grid :color => "gray(0.7)", :width => 0.5
				tics :yes
				stubs format_data(%w(text Mon Tue Wed Thu Fri Sat Sun))
			end
			# draw y axis on left
			yaxis do
				stubslide -(@height / 2)
				stubrange 0, @weeks
				labels = @labels.map {|l| l[0]}
				stubdetails :adjust => "-.25,0"
				grid :color => "gray(0.7)", :width => 0.5
				tics :yes
				stubs format_data(['text'] + labels)
			end
			# draw y axis on right
			yaxis do
				location '7(s)'
				stubslide -(@height / 2)
				stubrange 0, @weeks
				labels = @labels.map {|l| l[1]}
				stubdetails :adjust => "#{@width},0"
				tics :yes
				stubs format_data(['text'] + labels)
			end
			# loop through each cell
			@cell_id = 0
			(@weeks-1).downto(0) do |row|
				0.upto(6) do |col|
					@cell_id += 1
					# set up cell area
					areadef do
						_clone :cell
						location col * @width, row * @height
					end
					# draw bars
					bars do
						_clone :bars
						self.select "@@3 = #{@cell_id}"
					end
				end
			end
			# loop through each row for line plots
			1.upto(@weeks) do |row|
				# set up the area for the row
				areadef do
					location 0, @height * (@weeks - row)
					box @width * 7, @height
					xrange 0, 7
					yrange 0, @max*1.1
					# draw the left axis
					group :yaxis do
						stubs "inc 1000"
						stubdetails :size => 3
						stubrange 0, @max-1 if row > 1
					end
				end
				# draw the lineplot
				lineplot do
					xfield 1
					yfield 2
					linedetails :color => :blue, :width => 2
					self.select "@@3 = #{-row}"
				end
			end
			# now list the actual data
			trailer { data format_data(@data) }
		end.render(:svg)
	end

	# take a date table and convert it into coordinate and label lists
	# for ploticus to use. includes both bar and summary data in the list,
	# in the format [loc, len, group], where group = +cell_id or -week_id.
	# use cell_id for bars, and week_id for summaries.
	def chart_weekly(table, stat)
		cell_id, week_id, max, data, labels = 0, 0, 0, [], []
		# iterate each week
		table.each_week_of(stat) do |first,last,week|
			# record labels for this week
			week_id -= 1
			labels << [	first.strftime('%m-%d'),
									last.strftime('%m-%d')]
			# iterate each day
			week.each_with_index do |day,i|
				# update maximum summary value for y range
				cell_id, summary, measurements = cell_id+1, day[0], day[1..-1]
				next if summary.nil?
				max = summary if summary > max
				# add summary data to list (centered in cell)
				data << [i + 0.5, summary, week_id]
				# each hour's measurements are stacked
				measurements.group_by(&:adjusted_hour).each do |hour,meas|
					values = meas.map {|m| m.denormalized}
					loc, len = hour, values.sum
					# stack cumulative bars last-to-first
					values.reverse.each do |v|
						data << [loc, len, cell_id]
						len -= v
					end
				end
			end
		end
		# construct ploticus options
		{
			:max => max,
			:data => data,
			:labels => labels,
			:weeks => table.num_weeks,
			:height => 0.5,
			:width => 0.7,
			:marg => 0.2,
			:bars => 0.02333
		}
	end

private

	# get a range of days from num days ago to present
	def since_days_ago(num)
		num.days.ago.to_date .. Date.today
	end

end
