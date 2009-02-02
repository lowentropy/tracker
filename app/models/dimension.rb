class Dimension < ActiveRecord::Base

	acts_as_list

	has_many :stats, :dependent => :destroy
	has_many :units, :dependent => :destroy

end
