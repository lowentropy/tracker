class PersonStatsController < ApplicationController
  # GET /person_stats
  # GET /person_stats.xml
  def index
    @person_stats = PersonStat.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @person_stats }
    end
  end

  # GET /person_stats/1
  # GET /person_stats/1.xml
  def show
    @person_stat = PersonStat.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @person_stat }
    end
  end

  # GET /person_stats/new
  # GET /person_stats/new.xml
  def new
    @person_stat = PersonStat.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @person_stat }
    end
  end

  # GET /person_stats/1/edit
  def edit
    @person_stat = PersonStat.find(params[:id])
  end

  # POST /person_stats
  # POST /person_stats.xml
  def create
    @person_stat = PersonStat.new(params[:person_stat])

    respond_to do |format|
      if @person_stat.save
        flash[:notice] = 'PersonStat was successfully created.'
        format.html { redirect_to(@person_stat) }
        format.xml  { render :xml => @person_stat, :status => :created, :location => @person_stat }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @person_stat.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /person_stats/1
  # PUT /person_stats/1.xml
  def update
    @person_stat = PersonStat.find(params[:id])

    respond_to do |format|
      if @person_stat.update_attributes(params[:person_stat])
        flash[:notice] = 'PersonStat was successfully updated.'
        format.html { redirect_to(@person_stat) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @person_stat.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /person_stats/1
  # DELETE /person_stats/1.xml
  def destroy
    @person_stat = PersonStat.find(params[:id])
    @person_stat.destroy

    respond_to do |format|
      format.html { redirect_to(person_stats_url) }
      format.xml  { head :ok }
    end
  end
end
