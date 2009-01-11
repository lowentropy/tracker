class Dimension < ActiveRecord::Base

	has_many :stats, :dependent => :destroy
	has_many :units, :dependent => :destroy

end
