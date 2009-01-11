class Unit < ActiveRecord::Base

	belongs_to :dimension
	has_many :unit_prefs, :dependent => :destroy

end
