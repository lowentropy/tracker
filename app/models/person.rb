class Person < ActiveRecord::Base

	has_many :measurements, :dependent => :destroy
	has_many :person_graphs, :dependent => :destroy
	belongs_to :user

end
