class Graph < ActiveRecord::Base
	
	belongs_to :person
	has_many :plots, :dependent => :destroy

end
