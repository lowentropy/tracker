class Stat < ActiveRecord::Base

	belongs_to :dimension
	belongs_to :user
	has_many :measurements, :dependent => :destroy
	has_many :unit_prefs, :dependent => :destroy
	has_many :plots, :dependent => :destroy
	has_many :person_stats, :dependent => :destroy

end
