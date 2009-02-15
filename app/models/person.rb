class Person < ActiveRecord::Base

	has_many :graphs, :dependent => :destroy
	has_many :stats, :dependent => :destroy, :order => :position

	def stat(stat_or_name)
		if stat_or_name.is_a? Stat
			stat_or_name
		else
			stats.find :first, :conditions =>
				["name LIKE ?", stat_or_name+'%']
		end
	end

	def table(range=since_days_ago(30))
		stats.visible.map do |stat|
			stat.measurements.inside(range).group_by(&:day)
		end.extend DateTable
	end

	def measure(stat_or_name, time, value, unit=nil)
		stat = self.stat(stat_or_name)
		raise "unknown stat: #{stat_or_name}" unless stat
		value = Unit.normalize(value, unit || stat.unit)
		stat.measurements.create :measured_at => time, :value => value
	end

	# quick-add. format: [<num> [<unit>]] <stat> [(at|@) <time>]
	def quick(sentence)
		words = sentence.split(/\s+/)
		
		# use the explicitly given date/time
		time = DateTime.now
		if i = words.index('at') || words.index('@')
			time = words[i+1..-1].join ' '
			words = words[0...i]
		end

		# use the explicitly given numeric value
		value = 1.0
		if words[0].to_f != 0.0
			value = words.shift.to_f
			# modify the value with an explicitly given unit
			if words.size > 1
				value = "#{value} #{words.shift}"
			end
		end

		# throw out bad sentences
		throw "invalid sentence" if words.size != 1
		measure words[0], time, value
	end

	def first_hour
		day_begins_at.strftime '%l%P'
	end

	def first_hour=(hour)
		self.day_begins_at = Time.parse(hour)
	end

	def plot_weekly(stat_or_name)
		meas = self.stat(stat_or_name).measurements
		days = meas.group_by &:day
		weeks = days.group_by {|a| a[1][0].week}
		max, base, data = 0, 0, [] # loc len cellid
		rows = []
		weeks.each do |wlabel,week|
			rows << []
			a = week[0][1][0].day_of_week
			b = week[-1][1][0].day_of_week
			a.times { rows[-1] << 0 }
			week.each do |day_meas|
				rows[-1] << 0
				day, measurements = day_meas
				cellid = base + measurements[0].day_of_week + 1
				measurements.each do |m|
					loc = (m.measured_at.hour - day_begins_at.hour) % 24
					len = m.value
					data << [loc, len, cellid]
					max = len if len > max
					rows[-1][-1] += len
				end
			end
			(6 - b).times { rows[-1] << 0 }
			base += 7
		end

		opts = {
			:rows => rows,
			:data => data,
			:max_y => max,
			:row_height => 0.5,
			:col_width => 0.7,
			:marg_height => 0.2,
			:bar_width => 0.02333
		}

		p = Ploticus.script(opts) do

			# set page title
			page { title "Calories consumed" }

			# get the data from the trailer
			getdata { meta "#intrailer" }

			# define how a cell looks
			procdef :areadef do
				xrange -1, 24
				yrange 0, @max_y
				box @col_width, @row_height
				frame :yes
				saveas :cell
			end

			# define how the bars should look
			procdef :bars do
				color :red
				outline :no
				barsrange 0, 23
				barwidth @bar_width
				locfield 1
				lenfield 2
				saveas :bars
			end

			# first, draw the overall grid TODO
			#areadef do
			#	rectange 0, 0, rows[0].size * @col_width, rows.size * @row_height
			#	xscaletype :categories
			#	xrange :categories
			#	yscaletype :date
			#	yrange 
			#end

			# loop through each cell
			@cellid = 0
			rows.each_with_index do |row,i|
				row.each_with_index do |unused,j|
					@cellid += 1

					# set up cell area
					areadef do
						clone :cell
						x = j * @col_width
						y = (rows.size - i - 1) * @row_height
						location x, y
					end

					# draw cell's bars
					bars do
						clone :bars
						self.select "@@3 = #{@cellid}"
					end
				end
			end

			# now list the actual data
			trailer { data @data }
		end

		p.save "test.png"
	end

private

	def since_days_ago(num)
		num.days.ago.to_date .. Date.today
	end

end
