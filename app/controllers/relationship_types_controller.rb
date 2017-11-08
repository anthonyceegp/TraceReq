class RelationshipTypesController < ApplicationController
  before_action :set_project, only: [:index, :new, :create]
  before_action :set_project_relationship_type, except: [:index, :new, :create]

  # GET /relationship_types
  # GET /relationship_types.json
  def index
    @relationship_types = RelationshipType.where(project: @project)
  end

  # GET /relationship_types/1
  # GET /relationship_types/1.json
  def show
  end

  # GET /relationship_types/new
  def new
    @relationship_type = RelationshipType.new
  end

  # GET /relationship_types/1/edit
  def edit
  end

  # POST /relationship_types
  # POST /relationship_types.json
  def create
    @relationship_type = @project.relationship_types.build(relationship_type_params)

    respond_to do |format|
      if @relationship_type.save
        format.html { redirect_to [@project, @relationship_type], notice: 'Relationship type was successfully created.' }
        format.json { render :show, status: :created, location: [@project, @relationship_type] }
      else
        format.html { render :new }
        format.json { render json: @relationship_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /relationship_types/1
  # PATCH/PUT /relationship_types/1.json
  def update
    respond_to do |format|
      if @relationship_type.update(relationship_type_params)
        format.html { redirect_to [@project, @relationship_type], notice: 'Relationship type was successfully updated.' }
        format.json { render :show, status: :ok, location: [@project, @relationship_type] }
      else
        format.html { render :edit }
        format.json { render json: @relationship_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /relationship_types/1
  # DELETE /relationship_types/1.json
  def destroy
    @relationship_type.destroy
    respond_to do |format|
      format.html { redirect_to project_relationship_types_url(@project), notice: 'Relationship type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:project_id])
    end

    def set_project_relationship_type
      @project = Project.find(params[:project_id])
      @relationship_type = @project.relationship_types.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def relationship_type_params
      params.require(:relationship_type).permit(:name)
    end
end
