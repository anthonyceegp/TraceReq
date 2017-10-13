class User < ApplicationRecord
	# Include default devise modules. Others available are:
	# :omniauthable and :registerable
	devise :database_authenticatable,
	:recoverable, :rememberable, :trackable, :validatable,
	:confirmable, :lockable, :timeoutable

	def password_required?
		super if confirmed?
	end

	def password_match?
		errors.add(:password, "can't be blank") if password.blank?
		errors.add(:password_confirmation, "can't be blank") if password_confirmation.blank?
		errors.add(:password_confirmation, "does not match password") if password != password_confirmation
		password == password_confirmation && !password.blank?
	end
end
