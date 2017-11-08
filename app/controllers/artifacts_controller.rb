class ArtifactsController < ApplicationController
  before_action :set_project_demand, only: [:index, :new, :create]
  before_action :set_project_demand_artifact, except: [:index, :new, :create]
  before_action :set_select_collections, only: [:edit, :update, :new, :create]

  # GET /artifacts
  # GET /artifacts.json
  def index
    @artifacts = @demand.artifacts.order(:artifact_type_id, :code).page(params[:page]).per(8)
  end

  # GET /artifacts/1
  # GET /artifacts/1.json
  def show
    @show_import_button = false
    if @artifact.nil?
      @artifact = Artifact.find(params[:id])
      @show_import_button = true
    end
    @number_conflict = ArtifactDemand.where(artifact: @artifact).count
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
        @artifact.artifact_demands.create(demand: @demand, user: current_user)
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
    respond_to do |format|
      # if the artifact belongs to no other demands, it can be deleted
      if @artifact.demands.where.not(id: @demand.id).any?
        # if the artifact belongs to other demand, user may choose to revert all changes
        last_version = @artifact.versions.last.index
        first_version = @artifact.artifact_demands.select(:artifact_version).where(demand: @demand).first.artifact_version
        # if last version is higher than first version, it means that artifact was changed
        if last_version > first_version 
          format.html { redirect_to artifact_versions_url(@project, @demand, @artifact), alert: 'Artifact was changed.' }
          format.json { render :versions, status: :unprocessable_entity, location: artifact_versions_url(@demand, @project, @artifact)}
        else
          # if no change was made, the artifact will be removed from demand
          @artifact.demands.delete(@demand)
          format.html { redirect_to project_demand_artifacts_url(@project, @demand), notice: 'Artifact was successfully removed.' }
          format.json { head :no_content }
        end
      else
        @artifact.destroy
        format.html { redirect_to project_demand_artifacts_url(@project, @demand), notice: 'Artifact was successfully destroyed.' }
        format.json { head :no_content }
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
    artifact_version = @artifact.versions.last.index
    @artifact.artifact_demands.create(demand: @demand, user_id: current_user.id, artifact_version: artifact_version)
    respond_to do |format|
      format.html { redirect_to [@project, @demand, @artifact], notice: 'Artifact was successfully imported.' }
      format.json { render :show, status: :created, location: [@project, @demand, @artifact] }
    end
  end

  def versions
    last_index = @artifact.versions.last.index
    first_index = @artifact.artifact_demands.select(:artifact_version).where(demand: @demand).first.artifact_version
    @versions = @artifact.versions[first_index..last_index]
  end

  def reify
    respond_to do |format|
      if params[:index]
        indexx = params[:index].to_i 
        version = @artifact.versions[indexx]
        artifact = version.reify
        artifact.save
        artifact.versions.where('created_at >= ?', version.created_at).delete_all
        indexx = artifact.versions.last.index
        ArtifactDemand.where(artifact: artifact).where('artifact_version > ?', indexx).update_all(artifact_version: indexx)
        @artifact.demands.delete(@demand)
        format.html { redirect_to project_demand_artifacts_url(@project, @demand), notice: 'Artifact was successfully removed and reified.' }
        format.json { head :no_content }
      else
        format.html {redirect_to artifact_versions_url(@project, @demand, @artifact), alert: 'Select one version to reify.'}
        format.json { render :versions, status: :unprocessable_entity, 
                                        location: artifact_versions_url(@demand, @project, @artifact)}
      end
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
