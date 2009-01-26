class SummaryModesController < ApplicationController
  # GET /summary_modes
  # GET /summary_modes.xml
  def index
    @summary_modes = SummaryMode.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @summary_modes }
    end
  end

  # GET /summary_modes/1
  # GET /summary_modes/1.xml
  def show
    @summary_mode = SummaryMode.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @summary_mode }
    end
  end

  # GET /summary_modes/new
  # GET /summary_modes/new.xml
  def new
    @summary_mode = SummaryMode.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @summary_mode }
    end
  end

  # GET /summary_modes/1/edit
  def edit
    @summary_mode = SummaryMode.find(params[:id])
  end

  # POST /summary_modes
  # POST /summary_modes.xml
  def create
    @summary_mode = SummaryMode.new(params[:summary_mode])

    respond_to do |format|
      if @summary_mode.save
        flash[:notice] = 'SummaryMode was successfully created.'
        format.html { redirect_to(@summary_mode) }
        format.xml  { render :xml => @summary_mode, :status => :created, :location => @summary_mode }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @summary_mode.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /summary_modes/1
  # PUT /summary_modes/1.xml
  def update
    @summary_mode = SummaryMode.find(params[:id])

    respond_to do |format|
      if @summary_mode.update_attributes(params[:summary_mode])
        flash[:notice] = 'SummaryMode was successfully updated.'
        format.html { redirect_to(@summary_mode) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @summary_mode.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /summary_modes/1
  # DELETE /summary_modes/1.xml
  def destroy
    @summary_mode = SummaryMode.find(params[:id])
    @summary_mode.destroy

    respond_to do |format|
      format.html { redirect_to(summary_modes_url) }
      format.xml  { head :ok }
    end
  end
end
