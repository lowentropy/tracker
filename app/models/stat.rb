class Stat < ActiveRecord::Base

	belongs_to :dimension
	belongs_to :person
	belongs_to :unit
	belongs_to :summary_mode

	has_many :measurements, :dependent => :destroy
	has_many :plots, :dependent => :destroy
	has_many :units, :through => :dimension

	named_scope :visible, :conditions => {:visible => true}

end
