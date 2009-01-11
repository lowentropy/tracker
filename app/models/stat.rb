class Stat < ActiveRecord::Base

	belongs_to :dimension
	has_many :measurements, :dependent => :destroy
	has_many :unit_prefs, :dependent => :destroy

end
