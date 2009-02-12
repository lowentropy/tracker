class Graph < ActiveRecord::Base
	
	belongs_to :person
	has_many :plots, :dependent => :destroy

	def chart_url
		base = "http://chart.apis.google.com/chart"
		params = {
			:chs => chart_size,
			:cht => chart_type,
			:chl => []
		}
	end

	def chart_size
		"#{width}x#{height}"
	end

	def chart_type
	end

end
