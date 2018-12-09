class ProjectsController < ApplicationController
  load_and_authorize_resource
  
  before_action :set_project, except: [:index, :new, :create]


  # GET /projects
  # GET /projects.json
  def index
    if @current_user.roles.include?(:admin)
      @projects = Project.search(params[:term])
    else
      @projects = @current_user.projects.search(params[:term])
    end

    @projects = @projects.page(params[:page]).per(7)
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = current_user.projects.build(project_params)
    @project.user = current_user
    
    respond_to do |format|
      if @project.save
        @project.users << current_user
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def users
    @users = @project.users.search(params[:term]).page(params[:page]).per(7)
  end

  def add_users
    @users = User.where(deleted_at: nil).where.not(id: @project.users.ids).where('confirmed_at IS NOT NULL').search(params[:term]).page(params[:page]).per(6)
  end

  def save_add_users
    users = User.find(add_users_params[:user_ids])
    users.each do |user|
      user.projects << @project
    end

    respond_to do |format|
      format.html { redirect_to project_add_users_url(@project), notice: 'Users was successfully added.' }
      format.json { render :add_users, status: :ok, location: project_add_users_url(@project)}
    end
  end

  def remove_user
    user = @project.users.find(params[:user_id])
    @project.users.delete(user)
    respond_to do |format|
      format.html { redirect_to project_users_url(@project), notice: 'User was successfully removed.' }
      format.json { render :users, status: :ok, location: project_users_url(@project) }
    end
  end

  def status
    statuses = @project.artifact_statuses 
    i=0
    statusMap = statuses.map{|s| {(i+=1)-1=>s.id}}.reduce(:merge)
    @legends = statuses.pluck(:name)
    @days = (@project.created_at.to_date..Date.current()).map{ |date| date }
    @series = []
    data = Array.new(statuses.size) { Array.new(@days.size, 0.0) }
    @days.each_with_index do |day, index|
      temp = []
      ChartDatum.where(artifact: @project.artifacts).where("DATE(created_at) <= ?", day).order(created_at: :desc).each do |chart_datum|
        temp << chart_datum unless temp.any? { |c| c.artifact_id == chart_datum.artifact_id }
      end
      aritfact_num = @project.artifacts.where('DATE(created_at) <= ?', @days[index]).size
      temp.each do |d|
        if aritfact_num == 0
          data[statusMap.key(d.artifact_status.id)][index] = 0.0
        else
          data[statusMap.key(d.artifact_status.id)][index] += 100.0 / aritfact_num
        end
      end
    end

    statuses.each_with_index do |s, index|
      @series << {name: s.name, type: "line", data: data[index].map {|c| c = c.round}}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:name, :description)
    end

    def add_users_params
      params.permit(user_ids: [])
    end
end
