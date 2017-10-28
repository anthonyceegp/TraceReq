class DemandsController < ApplicationController
  before_action :set_project, only: [:index, :new, :create]
  before_action :set_project_demand, except: [:index, :new, :create]
  before_action :set_statuses_collection, only: [:new, :edit, :create, :update]

  # GET /demands
  # GET /demands.json
  def index
    @demands = Demand.all
  end

  # GET /demands/1
  # GET /demands/1.json
  def show
  end

  # GET /demands/new
  def new
    @demand = @project.demands.build
  end

  # GET /demands/1/edit
  def edit
  end

  # POST /demands
  # POST /demands.json
  def create
    @demand = @project.demands.build(demand_params)
    @demand.user_create = current_user

    respond_to do |format|
      if @demand.save
        @demand.users << current_user
        format.html { redirect_to [@project, @demand], notice: 'Demand was successfully created.' }
        format.json { render :show, status: :created, location: [@project, @demand] }
      else
        puts @demands.nil?
        format.html { render :new }
        format.json { render json: @demand.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /demands/1
  # PATCH/PUT /demands/1.json
  def update
    respond_to do |format|
      if @demand.update(demand_params)
        format.html { redirect_to [@project, @demand], notice: 'Demand was successfully updated.' }
        format.json { render :show, status: :ok, location: [@project, @demand] }
      else
        format.html { render :edit }
        format.json { render json: @demand.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /demands/1
  # DELETE /demands/1.json
  def destroy
    @demand.destroy
    respond_to do |format|
      format.html { redirect_to @project, notice: 'Demand was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def remove_artifact
    artifact = @demand.artifacts.find(params[:artifact_id])
    @demand.artifacts.delete(artifact)
    respond_to do |format|       
      format.html { redirect_to [@project, @demand], notice: 'Artifact was successfully removed.' }
      format.json { render :import, status: :ok, location: [@project, @demand]}
    end
  end

  def import
     ids = ArtifactDemand.where(demand: @demand).select(:artifact_id)
    @artifacts = Artifact.all.where.not(id: ids).order(:artifact_type_id, :code).page(params[:page]).per(7)
  end

  def save_import
    artifacts = Artifact.find(import_params[:artifact_ids])
    artifacts.each do |artifact|
      artifact.artifact_demands.create(demand: @demand, user_included_id: current_user.id)
    end

    respond_to do |format|
      format.html { redirect_to import_artifacts_url(@project, @demand), notice: 'Artifacts was successfully imported.' }
      format.json { render :import, status: :ok, location: import_artifacts_url(@project, @demand)}
    end
  end

  private
    def set_project
      @project = Project.find(params[:project_id])
    end

    def set_project_demand
      @project = Project.find(params[:project_id])
      @demand = @project.demands.find(params[:id])
    end

    def set_statuses_collection
      @statuses = Demand.statuses
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def demand_params
      params.require(:demand).permit(:name, :description, :status, :release)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def import_params
      params.permit(artifact_ids: [])
    end
end
