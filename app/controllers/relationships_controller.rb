class RelationshipsController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource :relationship, through: :project

  before_action :set_relationship, only: [:show, :edit, :update, :destroy]
  before_action :set_project_demand, only: [:index, :new, :create, :filter]
  before_action :set_artifact_collection, only: [:new, :edit, :create]
  before_action :set_artifact_type_collection, only: [:index, :filter]
  before_action :set_relationship_type_collection, only: [:index, :new, :edit, :create, :filter]
  before_action :set_demand_collection, only: [:index, :filter]

  # GET /relationships
  # GET /relationships.json
  def index
    @filter = Filter.new(filter_params)
    @matrix = Relationship.matrix(@project, @demand, @filter)
  end

  # GET /relationships/1
  # GET /relationships/1.json
  def show
  end

  # GET /relationships/new
  def new
    if(params.key?(:origin_artifact_id) and params.key?(:end_artifact_id))
      origin_artifact = @project.artifacts.find(params[:origin_artifact_id])
      end_artifact = @project.artifacts.find(params[:end_artifact_id])

      @relationship = @project.relationships.build(origin_artifact: origin_artifact, end_artifact: end_artifact)
    else
      @relationship = @project.relationships.build()
    end
  end

  # GET /relationships/1/edit
  def edit
  end

  # POST /relationships
  # POST /relationships.json
  def create
    @relationship = @project.relationships.build(relationship_params)
    @relationship.user = current_user

    respond_to do |format|
      if @relationship.save
        if request.format.html?
          format.html { redirect_to url_for(action: :show, id: @relationship), notice: 'Relationship was successfully created.' }
        else
          html_content = render_to_string partial: 'checked', locals: {relationship: @relationship}, layout: false
          format.json { render json: {data: html_content}, status: :created }
        end
      else
        if request.format.html?
          format.html { render :new }
        else
          response =  render_to_string partial: 'layouts/alerts',  locals: { alert: @relationship.errors.full_messages.join('<br>').html_safe() }
          format.json { render json: {errors: response}, status: :unprocessable_entity}
        end
      end
    end
  end

  # PATCH/PUT /relationships/1
  # PATCH/PUT /relationships/1.json
  def update
    respond_to do |format|
      if @relationship.update(relationship_params)
        format.html { redirect_to url_for(action: :show, id: @relationship), notice: 'Relationship was successfully updated.' }
        format.json { render :show, status: :ok, location: url_for(action: :show, id: @relationship) }
      else
        format.html { render :edit }
        format.json { render json: @relationship.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /relationships/1
  # DELETE /relationships/1.json
  def destroy
    origin_artifact_id = @relationship.origin_artifact.id
    end_artifact_id = @relationship.end_artifact.id

    @relationship.destroy
    respond_to do |format|
      if request.format.html?
        format.html { redirect_to url_for(action: :index), notice: 'Relationship was successfully destroyed.' }
      else
        html_content = render_to_string partial: 'unchecked', locals: {origin_artifact_id: origin_artifact_id, end_artifact_id: end_artifact_id}, layout: false
        format.json { render json: {data: html_content}, status: :ok }
      end
    end
  end

  private
    def set_artifacts
      project = Project.find(params[:project_id])
      if params.key?(:demand_id)
        demand = @project.demands.find(params[:demand_id])
        demand.artifacts.order(:artifact_type_id, :code)
      else
        project.artifacts.order(:artifact_type_id, :code)
      end
    end

    def set_relationship
      @project = Project.find(params[:project_id])
      @demand = @project.demands.find(params[:demand_id]) if params.key?(:demand_id)
      @relationship = @project.relationships.find(params[:id])
    end

    def set_project_demand
      @project = Project.find(params[:project_id])
      @demand = @project.demands.find(params[:demand_id]) if params.key?(:demand_id)
    end    

    def set_artifact_collection
      @artifacts = Project.find(params[:project_id]).artifacts.order(:code)
    end

    def set_artifact_type_collection
      @artifact_types = Project.find(params[:project_id]).artifact_types.order(:name)
    end

    def set_relationship_type_collection
      @relationship_types = Project.find(params[:project_id]).relationship_types.order(:name)
    end

    def set_demand_collection
      @demands = Project.find(params[:project_id]).demands.order(:name)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def relationship_params
      params.require(:relationship).permit(:origin_artifact_id, :end_artifact_id, :relationship_type_id, :description)
    end

    def filter_params
      params.require(:filter).permit(:show_all, :demand_id, :column_artifact_type_id, :row_artifact_type_id, :relationship_type_id) rescue nil
    end
end
