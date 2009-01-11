class Person < ActiveRecord::Base

	has_many :measurements, :dependent => :destroy
	belongs_to :user

end
