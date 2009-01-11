class Measurement < ActiveRecord::Base

	belongs_to :person
	belongs_to :stat
	has_many :logs, :dependent => :destroy

end
