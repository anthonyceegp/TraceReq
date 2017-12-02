class User < ApplicationRecord
	# Include default devise modules. Others available are:
	# :omniauthable and :registerable
	devise	:database_authenticatable, :recoverable,
					:rememberable, :trackable, :validatable,
					:confirmable, :lockable, :timeoutable

	has_attached_file :avatar, styles: {thumb: "32x32#", medium: "200x200"}, default_url: ":style/missing.png"
	validates_attachment_content_type :avatar, content_type: /\Aimage/
	validates_attachment_file_name :avatar, matches: [/png\z/, /jpe?g\z/]

	validates_presence_of :username, on: :update

	has_many :created_artifacts, class_name: "Artifact"
	has_many :created_relationships, class_name: "Relationship"
	has_many :created_projects, class_name: "Project"
	has_many :created_demands, class_name: "Demand"
	
	has_and_belongs_to_many :projects

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
