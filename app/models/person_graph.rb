class PersonGraph < ActiveRecord::Base

	belongs_to :person
	belongs_to :graph

	acts_as_list :scope => :person

end
