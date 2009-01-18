class PersonGraphsController < ApplicationController
  # GET /person_graphs
  # GET /person_graphs.xml
  def index
    @person_graphs = PersonGraph.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @person_graphs }
    end
  end

  # GET /person_graphs/1
  # GET /person_graphs/1.xml
  def show
    @person_graph = PersonGraph.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @person_graph }
    end
  end

  # GET /person_graphs/new
  # GET /person_graphs/new.xml
  def new
    @person_graph = PersonGraph.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @person_graph }
    end
  end

  # GET /person_graphs/1/edit
  def edit
    @person_graph = PersonGraph.find(params[:id])
  end

  # POST /person_graphs
  # POST /person_graphs.xml
  def create
    @person_graph = PersonGraph.new(params[:person_graph])

    respond_to do |format|
      if @person_graph.save
        flash[:notice] = 'PersonGraph was successfully created.'
        format.html { redirect_to(@person_graph) }
        format.xml  { render :xml => @person_graph, :status => :created, :location => @person_graph }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @person_graph.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /person_graphs/1
  # PUT /person_graphs/1.xml
  def update
    @person_graph = PersonGraph.find(params[:id])

    respond_to do |format|
      if @person_graph.update_attributes(params[:person_graph])
        flash[:notice] = 'PersonGraph was successfully updated.'
        format.html { redirect_to(@person_graph) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @person_graph.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /person_graphs/1
  # DELETE /person_graphs/1.xml
  def destroy
    @person_graph = PersonGraph.find(params[:id])
    @person_graph.destroy

    respond_to do |format|
      format.html { redirect_to(person_graphs_url) }
      format.xml  { head :ok }
    end
  end
end
