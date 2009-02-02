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

	def login
		fake_login and return
		session[:attempt] = request.url
		if (url = session[:user_openid_url])
			@user = User.find_by_openid_url session[:user_openid_url]
			unless @user
				flash[:notice] = 'Not a valid user, sorry.'
				redirect_to '/users'
			end
		else
			flash[:notice] = "Must log in to see #{request.url}"
			redirect_to '/users'
		end
	end

	def fake_login
		session[:person_id] ||= Person.find(:first).id
		@person = Person.find session[:person_id]
	end

	def set_time_zone
		# TODO: uncomment
		#Time.zone = @user.time_zone if @user
	end

end
