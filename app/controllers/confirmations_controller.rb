class ConfirmationsController < Devise::ConfirmationsController
	before_action :require_no_authentication
	skip_before_action :authenticate_user!

	def show
		if params[:confirmation_token].present?
			@original_token = params[:confirmation_token]
		elsif params[resource_name].try(:[], :confirmation_token).present?
			@original_token = params[resource_name][:confirmation_token]
		end

		self.resource = resource_class.find_by_confirmation_token(@original_token)
		
		super if resource.nil? or resource.confirmed?
	end

	def confirm
		@original_token = params[resource_name].try(:[], :confirmation_token)
		self.resource = resource_class.find_by_confirmation_token(@original_token)
		resource.assign_attributes(permitted_params) unless params[resource_name].nil?

		valid = resource.valid?
		matches = resource.password_match?

		if valid && matches
			self.resource.confirm
			set_flash_message :notice, :confirmed
			sign_in_and_redirect resource_name, resource
		else
			render action: 'show'
		end
	end

	private

	def permitted_params
		params.require(resource_name).permit(:confirmation_token, :username, :password, :password_confirmation)
	end
end
