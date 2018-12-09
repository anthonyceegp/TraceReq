class DemandsController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource :demand, through: :project

  before_action :set_project, only: [:index, :new, :create]
  before_action :set_project_demand, except: [:index, :new, :create]
  before_action :set_users_collection, only: [:new, :edit, :create, :update]

  # GET /demands
  # GET /demands.json
  def index
    @demands = @project.demands.search(params[:term]).page(params[:page]).per(7)
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

    respond_to do |format|
      if @demand.save
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
    respond_to do |format|
      if params[:keep] == "1" # User may choose to keep all changes made
        @demand.destroy
        format.html { redirect_to project_demands_url(@project), notice: 'Demand was successfully destroyed. All changes were kept.' }
        format.json { head :no_content }
      else # User may choose to revert all changes made
        # If there are conflicts, that is a artifact belongs to more then one demand or it was edited, user must analyze these before deleting demand
        if @demand.conflicted_artifacts.any?
          format.html { redirect_to conflict_demand_url(@project, @demand), alert: "Conflicts were found. To delete this demand, you may want to select an artifact version to keep it. Case you don't select any, it will be left as it is." }
          format.json { render json: conflicted_artifacts, status: :confict }
        else
          # Case there are no conflict, created artifacts can be safely destroyed.
          @demand.artifact_demands.each do |artifact_demand|
            if artifact_demand.status == "created"
              artifact_demand.artifact.destroy
            end
          end
          # Case there are no conflict, imported artifacts will be just removed.
          @demand.destroy
          format.html { redirect_to project_demands_url(@project), notice: 'Demand was successfully destroyed. All changes were undone.' }
          format.json { head :no_content }
        end
      end
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
    @artifacts = @demand.search_artifact_to_import(params[:term]).page(params[:page]).per(7)
  end

  def save_import
    artifacts = @project.artifacts.where(id: import_params[:artifact_ids])

    respond_to do |format|
      if artifacts.any?
        artifacts.each do |artifact|
          verison = artifact.versions.last
          artifact.artifact_demands.create(demand: @demand, user: current_user, status: :imported, version_index: verison.index)
        end
        format.html { redirect_to import_artifacts_url(@project, @demand), notice: 'Artifacts was successfully imported.' }
        format.json { render :import, status: :ok, location: import_artifacts_url(@project, @demand)}
      else
        format.html { redirect_to import_artifacts_url(@project, @demand), alert: 'Select at least one artifact to import.' }
        format.json { render :import, status: :unprocessable_entity , location: import_artifacts_url(@project, @demand)}
      end
    end
  end

  def conflict
    @conflicted_artifacts = @demand.conflicted_artifacts
  end

  def resolve_conflicts
    @demand.artifact_demands.each do |artifact_demand|
      artifact = artifact_demand.artifact
      artifact_id = artifact_demand.artifact.id.to_s

      if artifact_demand.edited? or artifact.conflict?
        artifact.revert_to(params[:versions][artifact_id].to_i) if params.has_key?(:versions) and !params[:versions][artifact_id].blank?
      else artifact_demand.status == "created"
        artifact.destroy
      end
    end
    @demand.destroy
    respond_to do |format|
      format.html { redirect_to project_demands_url(@project), notice: 'Demand was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def status
    statuses = @project.artifact_statuses 
    i=0
    statusMap = statuses.map{|s| {(i+=1)-1=>s.id}}.reduce(:merge)
    @legends = statuses.pluck(:name)
    @days = (@demand.created_at.to_date..Date.current()).map{ |date| date }
    @series = []
    data = Array.new(statuses.size) { Array.new(@days.size, 0.0) }
    @days.each_with_index do |day, index|
      temp = []
      ChartDatum.where(artifact: @demand.artifacts).where("DATE(created_at) <= ?", day).order(created_at: :desc).each do |chart_datum|
        temp << chart_datum unless temp.any? { |c| c.artifact_id == chart_datum.artifact_id }
      end

      aritfact_num = @demand.artifacts.where('DATE(artifacts.created_at) <= ?', @days[index]).size
      temp.each do |d|
        if aritfact_num == 0
          data[statusMap.key(d.artifact_status.id)][index] = 0.0
        else
          data[statusMap.key(d.artifact_status.id)][index] += 100.0 / aritfact_num
        end
      end
    end

    statuses.each_with_index do |s, index|
      @series << {name: s.name, type: "line", data: data[index].map {|c| c = c.to_i}}
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

    def set_users_collection
      @users = Project.find(params[:project_id]).users
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def demand_params
      params.require(:demand).permit(:name, :description, :release, :responsible_user_id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def import_params
      params.permit(artifact_ids: [])
    end
end
