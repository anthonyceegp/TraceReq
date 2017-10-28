class RelationshipsController < ApplicationController
  before_action :set_project_demand, only: [:index, :new, :create, :matrix]
  before_action :set_project_demand_relationship, only: [:show, :edit, :update, :destroy]
  before_action :set_artifacts_collections, only: [:new, :edit, :create, :update]

  # GET /relationships
  # GET /relationships.json
  def index
    @relationships = Relationship.joins("inner join artifacts a on relationships.origin_artifact_id = a.id").
                                  joins("inner join artifacts b on relationships.end_artifact_id = b.id").
                                  pluck("a.id as origin_artifact_id", "b.id as end_artifact_id")
    @artifacts = Artifact.all
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
    @relationship.user_create = current_user

    respond_to do |format|
      if @relationship.save
        @relationship.relationship_demands.create(demand: @demand, user_included_id: current_user.id)
        # format.html { redirect_to [@project, @demand, @relationship], notice: 'Relationship was successfully created.' }
        format.json { render json: @relationship.id, status: :created }
      else
        # format.html { render :new }
        format.json { render json: @relationship.errors, status: :unprocessable_entity }
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
      # format.html { redirect_to project_demand_relationships_url, notice: 'Relationship was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def matrix
    @relationships = Relationship.joins("inner join artifacts a on relationships.origin_artifact_id = a.id").
                                  joins("inner join artifacts b on relationships.end_artifact_id = b.id").
                                  pluck("a.id as origin_artifact_id", "b.id as end_artifact_id", "relationships.id")
    @artifacts = Artifact.all
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
