class UsersController < ApplicationController

  openid_enabled "User", :login_redirects_to => '/people'

	skip_before_filter :login
	before_filter :login, :except => [:index, :new, :create, :complete_login, :start_login]

  # GET /users
  def index
		@user = logged_in_user

    respond_to do |format|
      format.html # index.html.erb
    end
  end

	# GET /logout
	def logout
		reset_session
		flash[:notice] = "Later, #{@user.login}!"
		redirect_to users_url
	end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])

		if @user.openid_url != session[:user_openid_url]
			flash[:notice] = "Not your user!"
			redirect_to users_url
			return
		end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
		if @user.openid_url != session[:user_openid_url]
			flash[:notice] = "Not your user!"
			redirect_to users_url
			return
		end
  end

  # POST /users
  # POST /users.xml
  def create
		raise "new user creation not supported"

    @user = User.new(params[:user])
		@user.openid_url = session[:user_openid_url]

    respond_to do |format|
      if @user.save
        flash[:notice] = 'User was successfully created.'
        format.html { redirect_to(@user) }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

		if @user.openid_url != session[:user_openid_url]
			flash[:notice] = "Not your user!"
			redirect_to users_url
			return
		end

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy unless @user.openid_url != session[:user_openid_url]

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
end
