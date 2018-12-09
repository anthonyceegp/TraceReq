class User < ApplicationRecord
	devise	:database_authenticatable, :recoverable,
					:rememberable, :trackable, :validatable,
					:confirmable, :lockable, :timeoutable

	attr_accessor :remove_avatar

	before_save :delete_avatar, if: ->{ remove_avatar == '1' && !avatar_updated_at_changed? }

	validates :roles, presence: true

	has_attached_file :avatar, styles: {thumb: "32x32#", medium: "200x200"}, default_url: ":style/missing.png"
	validates_attachment_content_type :avatar, content_type: /\Aimage/
	validates_attachment_file_name :avatar, matches: [/png\z/, /jpe?g\z/]

	validates_presence_of :username, on: :update

	has_many :created_artifacts, class_name: "Artifact"
	has_many :created_relationships, class_name: "Relationship"
	has_many :created_projects, class_name: "Project"
	has_many :created_demands, class_name: "Demand"
	has_many :comments
	
	has_and_belongs_to_many :projects

	# belongs_to :role

	def password_required?
		super if confirmed?
	end

	def password_match?
		errors.add(:password, "can't be blank") if password.blank?
		errors.add(:password_confirmation, "can't be blank") if password_confirmation.blank?
		errors.add(:password_confirmation, "does not match password") if password != password_confirmation
		password == password_confirmation && !password.blank?
	end

	# instead of deleting, indicate the user requested a delete & timestamp it  
  def soft_delete  
    update_attribute(:deleted_at, Time.current)  
  end

  def restore
  	update_attribute(:deleted_at, nil)
  end
  
  # ensure user account is active  
  def active_for_authentication?  
    super && !deleted_at  
  end  
  
  # provide a custom message for a deleted account   
  def inactive_message   
  	!deleted_at ? super : :deleted_account  
  end 

	ROLES = %i[admin project_manager systems_analyst developer tester guest]

	def roles=(roles)
	  roles = [*roles].map { |r| r.to_sym }
	  self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.inject(0, :+)
	end

	def roles
	  ROLES.reject do |r|
	    ((roles_mask.to_i || 0) & 2**ROLES.index(r)).zero?
	  end
	end

	def has_role?(role)
	  roles.include?(role)
	end

	def self.search(term)
		if !term.blank?
			where('username ILIKE ? OR email ILIKE ?', "%#{term}%", "%#{term}%").order(:username)
		else
			order(:username)
		end
	end

	private

	def delete_avatar
		self.avatar = nil
	end
end
