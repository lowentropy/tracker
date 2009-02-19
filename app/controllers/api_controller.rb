class ApiController < ApplicationController

	skip_before_filter :login

	def quick
		person = Person.find_by_api_key params[:id]
		return unless person
		person.quick params[:message]
		render :text => 'measured, thx'
	end
	
end
