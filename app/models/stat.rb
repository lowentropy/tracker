class Stat < ActiveRecord::Base

	acts_as_list :scope => :person

	belongs_to :dimension
	belongs_to :person
	belongs_to :unit
	belongs_to :summary_mode

	has_many :measurements, :order => 'measured_at', :dependent => :destroy
	has_many :plots, :dependent => :destroy
	has_many :units, :through => :dimension

	named_scope :visible, :conditions => {:visible => true}

end
