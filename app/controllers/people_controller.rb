class PeopleController < ApplicationController

  openid_enabled "Person"

	skip_before_filter :login
	before_filter :login, :only => :reorder_person_stats
	before_filter :must_own_person, :only => [:show, :edit, :update, :delete]

	# GET /people/1/logout
	def logout
		reset_session
		redirect_to people_path
	end

	# POST /people/1/reorder_person_stats
	def reorder_person_stats
		params[:person_stats].each_with_index do |id,pos|
			PersonStat.update(id, :position => pos+1)
		end
		render :nothing => true
	end

  # GET /people
  # GET /people.xml
  def index
		@person = logged_in_person
    @people = Person.find :all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /people/1
  # GET /people/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @person }
    end
  end

  # GET /people/new
  # GET /people/new.xml
  def new
    @person = Person.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @person }
    end
  end

  # GET /people/1/edit
  def edit
  end

  # POST /people
  # POST /people.xml
  def create
    @person = Person.new(params[:person])

    respond_to do |format|
      if @person.save
        flash[:notice] = 'Person was successfully created.'
        format.html { redirect_to(@person) }
        format.xml  { render :xml => @person, :status => :created, :location => @person }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /people/1
  # PUT /people/1.xml
  def update
    respond_to do |format|
      if @person.update_attributes(params[:person])
        flash[:notice] = 'Person was successfully updated.'
        format.html { redirect_to(@person) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /people/1
  # DELETE /people/1.xml
  def destroy
    @person = Person.find(params[:id])
    @person.destroy

    respond_to do |format|
      format.html { redirect_to(people_url) }
      format.xml  { head :ok }
    end
  end

private

	def login_redirect(openid_url)
		session[:attempt] || measurements_path
	end

	def failed_login_redirect(state)
		flash[:notice] = "OpenID login falure: #{state.class.name}"
		people_path
	end

	# get the person by id, but also make sure it's the same as the
	# user who logged in by openid.
	def must_own_person
		@person = Person.find params[:id]
		if @person and @person.openid_url != session[:person_openid_url]
			flash[:notice] = 'Wrong person or not logged in!'
			redirect_to people_path
			return false
		end
		true
	end
end
