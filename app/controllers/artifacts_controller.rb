class ArtifactsController < ApplicationController
  before_action :set_artifact, except: [:index, :new, :create]
  before_action :build_artifact, only: [:create]
  before_action :set_project_demand_artifact, only: [:import]
  before_action :artifact_type_collections, only: [:edit, :update, :new, :create]

  def index
    @artifacts = artifacts.page(params[:page]).per(8)
  end

  def show
  end

  def new
    @artifact = Artifact.new
    @project = Project.find(params[:project_id])
    if params.key?(:demand_id)
      @demand = @project.demands.find(params[:demand_id])
    end
  end

  def edit
  end

  def create
    respond_to do |format|
      if @artifact.save
        @artifact.artifact_demands.create(demand: @demand, user: current_user, status: :created, version_index: 0) if params.key?(:demand_id)
        if params.key?(:file)
          attachment = @artifact.attachments.create(file: params[:file], artifact_version_index: @artifact.version_index)
          @artifact.attachment_id = attachment.id
          @artifact.paper_trail.without_versioning :save
        end
        format.html { redirect_to url_for(action: :show, id: @artifact), notice: 'Artifact was successfully created.' }
        format.json { render :show, status: :created, location: url_for(action: :show, id: @artifact) }
      else
        format.html { render :new }
        format.json { render json: @artifact.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      @artifact.assign_attributes(artifact_params)
      changed = @artifact.changed?
      puts changed
      if @artifact.update(artifact_params)
        @artifact.paper_trail.touch_with_version unless changed
        if params.key?(:file)
          attachment = @artifact.attachments.create(file: params[:file], artifact_version_index: @artifact.version_index)
          @artifact.attachment_id = attachment.id
          @artifact.paper_trail.without_versioning :save
        end
        format.html { redirect_to url_for(action: :show, id: @artifact), notice: 'Artifact was successfully updated.' }
        format.json { render :show, status: :ok, location: url_for(action: :show, id: @artifact) }
      else
        format.html { render :edit }
        format.json { render json: @artifact.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @artifact.destroy
    respond_to do |format|
      format.html { redirect_to url_for(action: :index), notice: 'Artifact was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def delete_file
    @artifact.attachment_id = nil
    @artifact.save
    respond_to do |format|
      format.html { redirect_to url_for(action: :show, id: @artifact), notice: 'File was successfully destroyed.' }
      format.json { render :show, status: :ok, location: url_for(action: :show, id: @artifact) }
    end
  end

  def import
    version = @artifact.versions.last
    @artifact.artifact_demands.create(demand: @demand, user_id: current_user.id, status: :imported, version_index: version.index)

    respond_to do |format|
      format.html { redirect_to url_for(action: :show, id: @artifact), notice: 'Artifact was successfully imported.' }
      format.json { render :show, status: :created, location: url_for(action: :show, id: @artifact) }
    end
  end

  def remove_revert
    respond_to do |format|
      if params[:commit] == "Remove Artifact"
        if params[:index]
          @artifact.revert_to(params[:index].to_i)
          @artifact.demands.delete(@demand)
          format.html { redirect_to url_for(action: :index), notice: 'Artifact was successfully removed and reverted.' }
          format.json { head :no_content }
        else
          @artifact.demands.delete(@demand)
          format.html { redirect_to url_for(action: :index), notice: 'Artifact was successfully removed.' }
          format.json { head :no_content }
        end
      elsif params[:commit] == "Revert Artifact"
        if params[:index]
          @artifact.revert_to(params[:index].to_i)
          format.html { redirect_to url_for(action: :index), notice: 'Artifact was successfully reverted.' }
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
    @versions = @artifact.versions[1..@artifact.version_index].sort_by{ |e| -e[:id] }
  end

  def demands
    @demands = @artifact.demands.order(:name).page(params[:page]).per(8)
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

    def set_artifact
      @show_import_button = false
      @show_remove_button = false
      @project = Project.find(params[:project_id])

      if params.key?(:demand_id)
        @demand = @project.demands.find(params[:demand_id])
        @artifact = @demand.artifacts.find_by_id(params[:id])
        @show_remove_button = true
        if @artifact.nil?
          @artifact = @project.artifacts.find(params[:id])
          @show_import_button = true
        end
      else
        @artifact = Project.find(params[:project_id]).artifacts.find(params[:id])
      end
    end

    def build_artifact
      @project = Project.find(params[:project_id])
      if params.key?(:demand_id)
        @demand = @project.demands.find(params[:demand_id])
        @artifact= @demand.artifacts.build(artifact_params)
      else
        @artifact = Artifact.new(artifact_params)
      end
      @artifact.project = @project
      @artifact.user = current_user
    end

    def set_project_demand_artifact
      @project = Project.find(params[:project_id])
      @demand = @project.demands.find(params[:demand_id])
      @artifact = @project.artifacts.find(params[:id])
    end

    def artifact_type_collections
      @artifact_types = ArtifactType.all
    end

    def artifact_params
      params.require(:artifact).permit(:code, :name, :description, :priority, :artifact_type_id)
    end
end