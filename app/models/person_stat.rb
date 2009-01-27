class PersonStat < ActiveRecord::Base

	acts_as_list :scope => :person

	belongs_to :person
	belongs_to :stat
	belongs_to :unit
	belongs_to :summary_mode

	named_scope :visible, :conditions => {:visible => true}

end
