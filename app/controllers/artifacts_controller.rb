class ArtifactsController < ApplicationController
  before_action :set_artifact, only: [:show, :edit, :update, :destroy]
  before_action :set_select_collections, only: [:edit, :update, :new, :create]
  before_action :set_project_demand

  # GET /artifacts
  # GET /artifacts.json
  def index
    @artifacts = Artifact.all
  end

  # GET /artifacts/1
  # GET /artifacts/1.json
  def show
    @artifact = @demand.artifacts.find(params[:id])
  end

  # GET /artifacts/new
  def new
    @artifact = Artifact.new
  end

  # GET /artifacts/1/edit
  def edit
    @artifact = @demand.artifacts.find(params[:id])
  end

  # POST /artifacts
  # POST /artifacts.json
  def create
    @artifact = @demand.artifacts.build(artifact_params)
    @artifact.user_create = current_user

    respond_to do |format|
      if @artifact.save
        @artifact.artifact_demands.create(demand: @demand, user_included_id: current_user.id)
        format.html { redirect_to [@project, @demand, @artifact], notice: 'Artifact was successfully created.' }
        format.json { render :show, status: :created, location: [@project, @demand, @artifact] }
      else
        format.html { render :new }
        format.json { render json: @artifact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /artifacts/1
  # PATCH/PUT /artifacts/1.json
  def update
    respond_to do |format|
      if @artifact.update(artifact_params)
        format.html { redirect_to [@project, @demand, @artifact], notice: 'Artifact was successfully updated.' }
        format.json { render :show, status: :ok, location: [@project, @demand, @artifact] }
      else
        format.html { render :edit }
        format.json { render json: @artifact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /artifacts/1
  # DELETE /artifacts/1.json
  def destroy
    @artifact.destroy
    respond_to do |format|
      format.html { redirect_to project_demand_artifacts_url, notice: 'Artifact was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_artifact
      @artifact = Artifact.find(params[:id])
    end

    def set_select_collections
      @artifact_types = ArtifactType.all
    end

    def set_project_demand
      @project = Project.find(params[:project_id])
      @demand = @project.demands.find(params[:demand_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def artifact_params
      params.require(:artifact).permit(:code, :name, :description, :priority, :artifact_type_id, :file)
    end
end
