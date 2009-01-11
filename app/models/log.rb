class Log < ActiveRecord::Base

	belongs_to :measurement
	belongs_to :user

end
