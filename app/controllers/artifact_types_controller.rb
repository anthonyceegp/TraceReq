class ArtifactTypesController < ApplicationController
  before_action :set_project, only: [:index, :new, :create]
  before_action :set_project_artifact_type, except: [:index, :new, :create]

  # GET /artifact_types
  # GET /artifact_types.json
  def index
    @artifact_types = ArtifactType.where(project: @project)
  end

  # GET /artifact_types/1
  # GET /artifact_types/1.json
  def show
  end

  # GET /artifact_types/new
  def new
    @artifact_type = ArtifactType.new
  end

  # GET /artifact_types/1/edit
  def edit
  end

  # POST /artifact_types
  # POST /artifact_types.json
  def create
    @artifact_type = @project.artifact_types.build(artifact_type_params)

    respond_to do |format|
      if @artifact_type.save
        format.html { redirect_to [@project, @artifact_type], notice: 'Artifact type was successfully created.' }
        format.json { render :show, status: :created, location: [@project, @artifact_type] }
      else
        format.html { render :new }
        format.json { render json: @artifact_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /artifact_types/1
  # PATCH/PUT /artifact_types/1.json
  def update
    respond_to do |format|
      if @artifact_type.update(artifact_type_params)
        format.html { redirect_to [@project, @artifact_type], notice: 'Artifact type was successfully updated.' }
        format.json { render :show, status: :ok, location: [@project, @artifact_type] }
      else
        format.html { render :edit }
        format.json { render json: @artifact_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /artifact_types/1
  # DELETE /artifact_types/1.json
  def destroy
    @artifact_type.destroy
    respond_to do |format|
      format.html { redirect_to project_artifact_types_url(@project), notice: 'Artifact type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:project_id])
    end

    def set_project_artifact_type
      @project = Project.find(params[:project_id])
      @artifact_type = @project.artifact_types.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def artifact_type_params
      params.require(:artifact_type).permit(:name)
    end
end
