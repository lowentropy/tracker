class Unit < ActiveRecord::Base

	belongs_to :dimension
	has_many :stats # don't delete

	named_scope :starts_with, proc {|name|
		part = name.downcase.singularize + '%'
		{:conditions =>
			["short_name LIKE ? OR long_name LIKE ?",
				part, part]}
	}

	def self.like(name, stat=nil)
		basis = stat ? stat.dimension.units : Unit
		basis.starts_with name
	end

	def self.parse(amount, stat=nil)
		idx = amount.rindex ' '
		raise "no unit in amount" unless idx
		value, name = amount[0,idx], amount[idx+1..-1]
		units = Unit.like name, stat
		if units.empty?
			raise "unit not found: #{name}"
		elsif units.size > 1
			names = units.map {|u| u.names}.join(", ")
			raise "ambiguous unit: #{name}; could be #{names}"
		else
			units.first.normalize value
		end
	end

	def self.normalize(value, unit=nil, stat=nil)
		if value =~ /[a-z]/i
			parse value, stat
		elsif unit
			unit.normalize value
		elsif stat and stat.unit
			stat.unit.normalize value
		else
			raise "must provide unit for #{value}"
		end
	end

	def normalize(value)
		value.to_f / multiplier
	end

	def denormalize(value)
		value.to_f * multiplier
	end

	def names
		"#{short_name}/#{long_name}"
	end

end
