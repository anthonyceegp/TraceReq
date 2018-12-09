class ArtifactStatusesController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource :artifact_status, through: :project

  before_action :set_project, only: [:index, :new, :create]
  before_action :set_project_artifact_status, except: [:index, :new, :create]

  # GET /artifact_statuses
  # GET /artifact_statuses.json
  def index
    @artifact_statuses = ArtifactStatus.where(project: @project).order(:name)
  end

  # GET /artifact_statuses/1
  # GET /artifact_statuses/1.json
  def show
  end

  # GET /artifact_statuses/new
  def new
    @artifact_status = ArtifactStatus.new
  end

  # GET /artifact_statuses/1/edit
  def edit
  end

  # POST /artifact_statuses
  # POST /artifact_statuses.json
  def create
    @artifact_status = @project.artifact_statuses.build(artifact_status_params)

    respond_to do |format|
      if @artifact_status.save
        format.html { redirect_to [@project, @artifact_status], notice: 'Artifact status was successfully created.' }
        format.json { render :show, status: :created, location: [@project, @artifact_status] }
      else
        format.html { render :new }
        format.json { render json: @artifact_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /artifact_statuses/1
  # PATCH/PUT /artifact_statuses/1.json
  def update
    respond_to do |format|
      if @artifact_status.update(artifact_status_params)
        format.html { redirect_to [@project, @artifact_status], notice: 'Artifact status was successfully updated.' }
        format.json { render :show, status: :ok, location: [@project, @artifact_status] }
      else
        format.html { render :edit }
        format.json { render json: @artifact_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /artifact_statuses/1
  # DELETE /artifact_statuses/1.json
  def destroy
    @artifact_status.destroy
    respond_to do |format|
      format.html { redirect_to project_artifact_statuses_url(@project), notice: 'Artifact status was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_project
      @project = Project.find(params[:project_id])
    end

    def set_project_artifact_status
      @project = Project.find(params[:project_id])
      @artifact_status = @project.artifact_statuses.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def artifact_status_params
      params.require(:artifact_status).permit(:name)
    end
end
