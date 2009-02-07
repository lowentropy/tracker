class Unit < ActiveRecord::Base

	belongs_to :dimension
	has_many :stats # don't delete

	def self.parse(amount)
		idx = amount.rindex ' '
		raise "no unit in amount" unless idx
		name = amount[idx+1..-1]
		unit = find_by_short_name(name)
		unit ||= find_by_long_name(name.singularize)
		raise "unit not found: #{name}" unless unit
		unit.normalize amount[0,idx]
	end

	def self.normalize(value, unit=nil)
		(value =~ /[a-zA-Z]/) ? parse(value) : unit.normalize(value)
	end

	def normalize(value)
		value.to_f / multiplier
	end

	def denormalize(value)
		value.to_f * multiplier
	end

end
