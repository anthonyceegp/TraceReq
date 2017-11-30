class RelationshipsController < ApplicationController
  before_action :set_relationship, only: [:show, :edit, :update, :destroy]
  before_action :set_project_demand, only: [:index, :new, :create, :filter]
  before_action :set_collections, only: [:new, :edit]

  # GET /relationships
  # GET /relationships.json
  def index
    @origin_artifacts = @end_artifacts = artifacts
    @relationships = @origin_artifacts.joins('inner join relationships on relationships.origin_artifact_id = artifacts.id')
                                      .select('relationships.origin_artifact_id','relationships.end_artifact_id', 'relationships.id')
    
    @artifact_types = ArtifactType.all.order(:name)
    @relationship_types = RelationshipType.all.order(:name)
    @demands = Demand.where(project: @project).order(:name)

    @has_artifacts = @origin_artifacts.empty? || @end_artifacts.empty? ? false : true 
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
          html_content = render_to_string partial: 'checked', locals: {relationship_id: @relationship.id, origin_artifact_id: @relationship.origin_artifact.id, end_artifact_id: @relationship.end_artifact.id}, layout: false
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

  def filter
    @origin_artifacts = @end_artifacts = Artifact.where(project: @project) if params[:show_all] == "1" or !params.key?(:demand_id)
    @origin_artifacts = @end_artifacts = @demand.artifacts if params[:show_all] == "0" and params.key?(:demand_id)

    @origin_artifacts = @end_artifacts = Demand.find(params[:demand_filter_id]).artifacts unless params[:demand_filter_id].blank?

    @origin_artifacts = @origin_artifacts.where(artifact_type_id: params[:origin_artifact_type_id]) unless params[:origin_artifact_type_id].blank?
    @end_artifacts = @end_artifacts.where(artifact_type_id: params[:end_artifact_type_id]) unless params[:end_artifact_type_id].blank?

    @origin_artifacts = @origin_artifacts.joins('inner join relationships on relationships.origin_artifact_id = artifacts.id')
                        .where('relationships.relationship_type_id = ?',params[:relationship_type_id]) unless params[:relationship_type_id].blank?
    
    @origin_artifacts = @origin_artifacts.order(:artifact_type_id, :code)
    @end_artifacts = @end_artifacts.order(:artifact_type_id, :code)
    
    @relationships = @origin_artifacts.joins('inner join relationships on relationships.origin_artifact_id = artifacts.id')
                                      .select('relationships.origin_artifact_id','relationships.end_artifact_id', 'relationships.id')
    
    if @origin_artifacts.empty? or @end_artifacts.empty?
      html_content = '<p>No relationship matches the selected filters.</p>'
    else
      html_content = render_to_string partial: 'matrix', layout: false
    end

    render json: {data: html_content }
  end

  private
    def artifacts
      @project = Project.find(params[:project_id])
      if params.key?(:demand_id)
        @demand = @project.demands.find(params[:demand_id])
        @demand.artifacts.order(:artifact_type_id, :code)
      else
        @project.artifacts.order(:artifact_type_id, :code)
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

    def set_collections
      @artifacts = Artifact.where(project_id: params[:project_id])
      @relationship_types = RelationshipType.where(project_id: params[:project_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def relationship_params
      params.require(:relationship).permit(:origin_artifact_id, :end_artifact_id, :relationship_type_id, :description)
    end
end
