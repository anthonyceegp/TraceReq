class UsersController < ApplicationController
before_action :set_user, only: [:show, :edit, :update, :destroy, :delete_user_avatar]

  # GET /users
  # GET /users.json
  def index
    @users = User.all.page(params[:page]).per(8)
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @users = []
    @users << User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @users = []

    user_create_params[:email].each do |email|
      user = User.new(email: email)
      if user.save
        user.send_confirmation_instructions
      else
        @users << user
      end
    end
    respond_to do |format|
      if @users.empty?
        format.html { redirect_to :new, notice: 'Users were successfully created.' }
        format.json { render :new, status: :created, location: :new }
      else
        flash.now[:alert] = "Some users couldn't be created."
        format.html { render :new }
        format.json { render json: @users, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_update_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def delete_user_avatar
    @user.avatar = nil
    @user.save
    respond_to do |format|
      format.html { redirect_to @user, notice: 'Avatar was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_create_params
      params.permit(email: [])
    end

    def user_update_params
      params.require(:user).permit(:username, :avatar)
    end
end
