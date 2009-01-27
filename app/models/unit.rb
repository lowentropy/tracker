class Unit < ActiveRecord::Base

	belongs_to :dimension
	has_many :unit_prefs, :dependent => :destroy
	has_many :person_stats, :dependent => :destroy

	def self.parse(amount)
		idx = amount.rindex ' '
		raise "no unit in amount" unless idx
		name = amount[idx+1..-1]
		unit   = find_by_short_name(name)
		unit ||= find_by_long_name(name.singularize)
		raise "unit not found: #{name}" unless unit
		amount[0,idx].to_f / unit.multiplier
	end

end
