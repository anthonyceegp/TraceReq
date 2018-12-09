class TemplatesController < ApplicationController
  before_action :set_project_template, only: [:show, :edit, :update, :destroy]
  before_action :set_project, only: [:index, :new, :create]
  before_action :set_models_collection, only: [:new, :edit]
 
  # GET /templates
  # GET /templates.json
  def index
    @templates = @project.templates
  end

  # GET /templates/1
  # GET /templates/1.json
  def show
  end

  # GET /templates/new
  def new
    @template = @project.templates.build()
  end

  # GET /templates/1/edit
  def edit
  end

  # POST /templates
  # POST /templates.json
  def create
    @template = @project.templates.build(template_params)
    @template.user = current_user

    respond_to do |format|
      if @template.save
        format.html { redirect_to [@project, @template], notice: 'Template was successfully created.' }
        format.json { render :show, status: :created, location: [@project, @template] }
      else
        format.html { render :new }
        format.json { render json: @template.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /templates/1
  # PATCH/PUT /templates/1.json
  def update
    respond_to do |format|
      if @template.update(template_params)
        format.html { redirect_to [@project, @template], notice: 'Template was successfully updated.' }
        format.json { render :show, status: :ok, location: [@project, @template] }
      else
        format.html { render :edit }
        format.json { render json: @template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /templates/1
  # DELETE /templates/1.json
  def destroy
    @template.destroy
    respond_to do |format|
      format.html { redirect_to project_templates_url(@project), notice: 'Template was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project_template
      @project = Project.find(params[:project_id])
      @template = @project.templates.find(params[:id])
    end

    def set_project
      @project = Project.find(params[:project_id])
    end

    def set_models_collection
      @models = Template.models
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def template_params
      params.require(:template).permit(:model, :content)
    end
end
