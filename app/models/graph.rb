class Graph < ActiveRecord::Base
	
	belongs_to :user
	has_many :plots, :dependent => :destroy
	has_many :person_graphs, :dependent => :destroy

end
