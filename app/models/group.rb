class Group < ActiveRecord::Base
	
	belongs_to :person
	has_many :stats, :order => :position # don't destroy

end
