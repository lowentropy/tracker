class ApiController < ApplicationController

	def quick
		person = Person.find_by_api_key params[:id]
		return unless person
		person.quick params[:message]
	end
	
end
