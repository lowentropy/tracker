class Person < ActiveRecord::Base

	has_many :measurements, :dependent => :destroy
	has_many :person_graphs, :dependent => :destroy
	has_many :person_stats, :dependent => :destroy, :order => :position
	has_many :stats, :through => :person_stats
	belongs_to :user

end
