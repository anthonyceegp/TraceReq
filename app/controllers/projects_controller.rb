class ProjectsController < ApplicationController
  before_action :set_project, except: [:index, :new, :create]

  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.all
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
    @project.user_create = current_user
    
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
    @users = @project.users.page(params[:page]).per(7)
  end

  def add_users
    @users = User.where.not(id: @project.users.ids).where('confirmed_at IS NOT NULL').
              select(:id, :email).page(params[:page]).per(7)
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
    demands = user.demands.includes(:project).where(project: @project)
    if demands.any?
      user.demands.delete(demands)
    end
    @project.users.delete(user)
    respond_to do |format|
      format.html { redirect_to project_users_url(@project), notice: 'User was successfully removed.' }
      format.json { render :users, status: :ok, location: project_users_url(@project) }
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
