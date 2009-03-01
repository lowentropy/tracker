class StatsController < ApplicationController
  # GET /stats
  # GET /stats.xml
  def index
    @stats = @person.stats

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @stats }
    end
  end

  # GET /stats/1
  # GET /stats/1.xml
  def show
    @stat = Stat.find(params[:id])
		raise "not owner" unless @stat.person.id == @person.id

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @stat }
    end
  end

	# GET /stats/1/plot.svg
	def plot
		@stat = Stat.find params[:id]
		raise "not owner" unless @stat.person.id == @person.id
		respond_to do |format|
			format.svg do
				table = @person.table(@person.stat_range(@stat))
				image = @person.plot_weekly(table, @stat)
				render :text => image
			end
			format.txt do
				values = @stat.measurements.map {|m| m.denormalized.to_i}
				title = "#{@stat.name} (in #{@stat.unit.long_name.pluralize})"
				text = "#{title}\n#{values.join("\n")}"
				render :text => text
			end
		end
	end

  # GET /stats/new
  # GET /stats/new.xml
  def new
    @stat = Stat.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @stat }
    end
  end

  # GET /stats/1/edit
  def edit
    @stat = Stat.find(params[:id])
  end

  # POST /stats
  # POST /stats.xml
  def create
    @stat = Stat.new(params[:stat])
		@stat.person_id = @person.id

    respond_to do |format|
      if @stat.save
        flash[:notice] = 'Stat was successfully created.'
        format.html { redirect_to(@stat) }
        format.xml  { render :xml => @stat, :status => :created, :location => @stat }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @stat.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /stats/1
  # PUT /stats/1.xml
  def update
    @stat = Stat.find(params[:id])

    respond_to do |format|
      if @stat.update_attributes(params[:stat])
        flash[:notice] = 'Stat was successfully updated.'
        format.html { redirect_to(@person) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @stat.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /stats/1
  # DELETE /stats/1.xml
  def destroy
    @stat = Stat.find(params[:id])
    @stat.destroy

    respond_to do |format|
      format.html { redirect_to(stats_url) }
      format.xml  { head :ok }
    end
  end
end
