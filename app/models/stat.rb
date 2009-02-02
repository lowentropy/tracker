class Stat < ActiveRecord::Base

	belongs_to :dimension
	belongs_to :person
	has_many :plots, :dependent => :destroy
	has_many :person_stats, :dependent => :destroy
	has_many :units, :through => :dimension

end
