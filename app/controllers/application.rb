# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
	layout 'tracker'
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '8c8514cbe8849bf094df28f86362dfcc'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

	before_filter :login
	before_filter :set_time_zone

private

	def debug_mode?
		ENV["RAILS_ENV"] == 'development'
	end

	def login
		fake_login and return if debug_mode?
		session[:attempt] = request.url
		if (url = session[:person_openid_url])
			@person = Person.find_by_openid_url url
			unless @person
				flash[:notice] = "#{url} is not a known OpenID."
				redirect_to people_path
			end
		else
			flash[:notice] = "Must log in to see #{request.url}."
			redirect_to people_path
		end
	end

	def fake_login
		session[:person_openid_url] ||= Person.find(:first).openid_url
		@person = Person.find_by_openid_url session[:person_openid_url]
	end

	def set_time_zone
		Time.zone = @person.time_zone if @person
	end

end
