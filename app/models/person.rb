class Person < ActiveRecord::Base

	has_many :person_graphs, :dependent => :destroy
	has_many :stats, :dependent => :destroy, :order => :position

	def stat(stat_or_name)
		if stat_or_name.is_a? Stat
			stat_or_name
		else
			stats.find :first, :conditions =>
				["name LIKE ?", stat_or_name+'%']
		end
	end

	def table(range=since_days_ago(10))
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

private

	def since_days_ago(num)
		num.days.ago.to_date .. Date.today
	end

end
