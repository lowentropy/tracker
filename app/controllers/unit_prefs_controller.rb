class UnitPrefsController < ApplicationController
  # GET /unit_prefs
  # GET /unit_prefs.xml
  def index
    @unit_prefs = UnitPref.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @unit_prefs }
    end
  end

  # GET /unit_prefs/1
  # GET /unit_prefs/1.xml
  def show
    @unit_pref = UnitPref.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @unit_pref }
    end
  end

  # GET /unit_prefs/new
  # GET /unit_prefs/new.xml
  def new
    @unit_pref = UnitPref.new
		@stat = Stat.find params[:stat_id]
		@units = @stat.dimension.units

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @unit_pref }
    end
  end

  # GET /unit_prefs/1/edit
  def edit
    @unit_pref = UnitPref.find(params[:id])
		@units = @unit_pref.unit.dimension.units
  end

  # POST /unit_prefs
  # POST /unit_prefs.xml
  def create
    @unit_pref = UnitPref.new(params[:unit_pref])
		@unit_pref.user_id = @user.id

    respond_to do |format|
      if @unit_pref.save
        flash[:notice] = 'UnitPref was successfully created.'
        format.html { redirect_to(unit_prefs_path) }
        format.xml  { render :xml => @unit_pref, :status => :created, :location => @unit_pref }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @unit_pref.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /unit_prefs/1
  # PUT /unit_prefs/1.xml
  def update
    @unit_pref = UnitPref.find(params[:id])

    respond_to do |format|
      if @unit_pref.update_attributes(params[:unit_pref])
        flash[:notice] = 'UnitPref was successfully updated.'
        format.html { redirect_to(unit_prefs_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @unit_pref.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /unit_prefs/1
  # DELETE /unit_prefs/1.xml
  def destroy
    @unit_pref = UnitPref.find(params[:id])
    @unit_pref.destroy

    respond_to do |format|
      format.html { redirect_to(unit_prefs_url) }
      format.xml  { head :ok }
    end
  end
end
