class ArtifactsController < ApplicationController
  before_action :set_artifact, only: [:show, :import, :history, :demands]
  before_action :set_project_demand, only: [:index, :new, :create]
  before_action :set_project_demand_artifact, except: [:index, :new, :create, :show, :import, :history, :demands]
  before_action :set_select_collections, only: [:edit, :update, :new, :create]

  # GET /artifacts
  # GET /artifacts.json
  def index
    @artifacts = @demand.artifacts.order(:artifact_type_id, :code).page(params[:page]).per(8)
  end

  # GET /artifacts/1
  # GET /artifacts/1.json
  def show
  end

  # GET /artifacts/new
  def new
    @artifact = Artifact.new
  end

  # GET /artifacts/1/edit
  def edit
  end

  # POST /artifacts
  # POST /artifacts.json
  def create
    @artifact = @demand.artifacts.build(artifact_params)
    @artifact.user = current_user
    @artifact.project = @project

    respond_to do |format|
      if @artifact.save
        @artifact.artifact_demands.create(demand: @demand, user: current_user, status: :created, version_index: 0)
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
    message = @artifact.destroy?(@demand)
    respond_to do |format|
      if message == ""
        format.html { redirect_to project_demand_artifacts_url(@project, @demand), notice: 'Artifact was successfully destroyed.' }
        format.json { head :no_content }
      else
        format.html { redirect_to artifact_versions_url(@project, @demand, @artifact), alert: message }
        format.json { render :versions, status: :unprocessable_entity, location: artifact_versions_url(@demand, @project, @artifact)}
      end
    end
  end

  def delete_file
    @artifact.file.destroy
    @artifact.save
    respond_to do |format|
      format.html { redirect_to [@project, @demand, @artifact], notice: 'File was successfully destroyed.' }
      format.json { render :show, status: :ok, location: project_demand_artifact_path(@project, @demand, @artifact) }
    end
  end

  def import
    version = @artifact.versions.last
    @artifact.artifact_demands.create(demand: @demand, user_id: current_user.id, status: :imported, version_index: version.index)

    respond_to do |format|
      format.html { redirect_to [@project, @demand, @artifact], notice: 'Artifact was successfully imported.' }
      format.json { render :show, status: :created, location: [@project, @demand, @artifact] }
    end
  end

  def versions
    last_index = @artifact.version_index
    first_index = @artifact.artifact_demands.where(demand: @demand).first.version.index + 1
    @versions = @artifact.versions[first_index..last_index]
  end

  def reify
    respond_to do |format|
      if params[:commit] == "Remove Artifact"
        if params[:index]
          @artifact.revert_to(params[:index].to_i)
          @artifact.demands.delete(@demand)
          format.html { redirect_to project_demand_artifacts_url(@project, @demand), notice: 'Artifact was successfully removed and reverted.' }
          format.json { head :no_content }
        else
          @artifact.demands.delete(@demand)
          format.html { redirect_to project_demand_artifacts_url(@project, @demand), notice: 'Artifact was successfully removed.' }
          format.json { head :no_content }
        end
      elsif params[:commit] == "Delete Artifact"
        @artifact.destroy
        format.html { redirect_to project_demand_artifacts_url(@project, @demand), notice: 'Artifact was successfully destroyed.' }
        format.json { head :no_content }
      elsif params[:commit] == "Revert Artifact"
        if params[:index]
          @artifact.revert_to(params[:index].to_i)
          format.html { redirect_to artifact_history_url(@project, @demand, @artifact), notice: 'Artifact was successfully reverted.' }
          format.json { head :no_content }
        else
          @artifact.errors[:base] << "You must select one version to revert."
          format.html { render :history }
          format.json { render json: @artifact.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def history
    @versions = @artifact.versions[1..@artifact.version_index]
  end

  def demands
    @demands = @artifact.demands.page(params[:page]).per(8)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_artifact
      @show_import_button = false
      @project = Project.find(params[:project_id])
      @demand = @project.demands.find(params[:demand_id])
      @artifact = @demand.artifacts.find_by_id(params[:id])
      if @artifact.nil?
        @artifact = Artifact.find(params[:id])
        @show_import_button = true
      end
    end

    def set_select_collections
      @artifact_types = ArtifactType.all
    end

    def set_project_demand
      @project = Project.find(params[:project_id])
      @demand = @project.demands.find(params[:demand_id])
    end

    def set_project_demand_artifact
      @project = Project.find(params[:project_id])
      @demand = @project.demands.find(params[:demand_id])
      @artifact = @demand.artifacts.find_by_id(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def artifact_params
      params.require(:artifact).permit(:code, :name, :description, :priority, :artifact_type_id, :file)
    end
end
