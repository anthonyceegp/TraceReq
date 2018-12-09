class RegistrationsController < Devise::RegistrationsController

	def edit
		@user = User.find(params[:id])
		authorize! :edit, @user
		super
	end

	def update
		@user = User.find(params[:id])
		authorize! :update, @user

		if @current_user.has_role?(:admin) and @current_user != @user
			respond_to do |format|
				if @user.update_without_password(user_params_to_admin)
					format.html { redirect_to @user, notice: 'User was successfully updated.' }
	        format.json { render :show, status: :ok, location: @user }
	      else
	        format.html { render :edit }
	        format.json { render json: @user.errors, status: :unprocessable_entity }
	      end
	    end
		else
			super
		end
	end

	protected

	def user_params_to_admin
		params.require(:user).permit(:email, roles: [])
	end
end
