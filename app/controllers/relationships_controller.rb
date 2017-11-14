class RelationshipsController < ApplicationController
  before_action :set_project_demand, only: [:index, :new, :create, :matrix, :filter]
  before_action :set_project_demand_relationship, only: [:show, :edit, :update, :destroy]
  before_action :set_artifacts_collections, only: [:new, :edit, :create, :update]

  # GET /relationships
  # GET /relationships.json
  def index
    @origin_artifacts = @end_artifacts = @demand.artifacts.order(:code)
    @relationships = @origin_artifacts.joins('inner join relationships on relationships.origin_artifact_id = artifacts.id').
                        pluck('relationships.origin_artifact_id','relationships.end_artifact_id', 'relationships.id')
    
    @artifact_types = ArtifactType.all.order(:name)
    @relationship_types = RelationshipType.all.order(:name)
  end

  # GET /relationships/1
  # GET /relationships/1.json
  def show
  end

  # GET /relationships/new
  def new
    @relationship = Relationship.new
  end

  # GET /relationships/1/edit
  def edit
  end

  # POST /relationships
  # POST /relationships.json
  def create
    @relationship = @demand.relationships.build(relationship_params)
    @relationship.user = current_user

    respond_to do |format|
      if @relationship.save
        @relationship.relationship_demands.create(demand: @demand, user: current_user, status: :created, version_index: 0)
        if request.format.html?
          format.html { redirect_to [@project, @demand, @relationship], notice: 'Relationship was successfully created.' }
        else
          format.json { render json: @relationship.id, status: :created }
        end
      else
        if request.format.html?
          format.html { render :new }
        else
          format.json { render json: @relationship.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /relationships/1
  # PATCH/PUT /relationships/1.json
  def update
    respond_to do |format|
      if @relationship.update(relationship_params)
        format.html { redirect_to [@project, @demand, @relationship], notice: 'Relationship was successfully updated.' }
        format.json { render :show, status: :ok, location: [@project, @demand, @relationship] }
      else
        format.html { render :edit }
        format.json { render json: @relationship.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /relationships/1
  # DELETE /relationships/1.json
  def destroy
    @relationship.destroy
    respond_to do |format|
      if request.format.html?
        format.html { redirect_to project_demand_relationships_url, notice: 'Relationship was successfully destroyed.' }
      else
        format.json { head :no_content }
      end
    end
  end

  def filter
    @origin_artifacts = @end_artifacts = Artifact.all unless params[:show_all] == "0"
    @origin_artifacts = @end_artifacts = @demand.artifacts unless params[:show_all] == "1"

    @origin_artifacts = @origin_artifacts.where(artifact_type_id: params[:origin_artifact_type_id]) unless params[:origin_artifact_type_id].blank?
    @end_artifacts = @end_artifacts.where(artifact_type_id: params[:end_artifact_type_id]) unless params[:end_artifact_type_id].blank?

    @origin_artifacts = @origin_artifacts.joins('inner join relationships on relationships.origin_artifact_id = artifacts.id')
                        .where('relationships.relationship_type_id = ?',params[:relationship_type_id]) unless params[:relationship_type_id].blank?
    
    @origin_artifacts = @origin_artifacts.order(:code)
    @end_artifacts = @end_artifacts.order(:code)
    
    @relationships = @origin_artifacts.joins('inner join relationships on relationships.origin_artifact_id = artifacts.id').
                        pluck('relationships.origin_artifact_id','relationships.end_artifact_id', 'relationships.id')
    
    if @origin_artifacts.empty? or @end_artifacts.empty?
      html_content = '<p>No relationship matches the selected filters.</p>'
    else
      html_content = render_to_string partial: 'matrix', layout: false
    end

    render json: {attachmentPartial: html_content }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project_demand
      @project = Project.find(params[:project_id])
      @demand = @project.demands.find(params[:demand_id])
    end

    def set_project_demand_relationship
      @project = Project.find(params[:project_id])
      @demand = @project.demands.find(params[:demand_id])
      @relationship = @demand.relationships.find(params[:id])
    end

    def set_artifacts_collections
      @artifacts = Artifact.all
      @relationship_types = RelationshipType.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def relationship_params
      params.require(:relationship).permit(:origin_artifact_id, :end_artifact_id, :relationship_type_id, :description)
    end
end
