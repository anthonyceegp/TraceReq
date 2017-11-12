class Artifact < ApplicationRecord
	has_paper_trail on: [:create, :update]

	before_destroy do 
		self.versions.destroy_all
	end

	has_attached_file :file
	validates_attachment :file, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png",
															"application/pdf", "application/doc", "application/msword"] }

	validates :code, presence: true, uniqueness: true, length: { maximum: 6}
	validates :name, presence: true
	validates :description, length: { maximum: 255}
	validates :artifact_type_id, presence: true

	belongs_to :artifact_type
	belongs_to :user
	belongs_to :project

	has_many :artifact_demands, dependent: :destroy
	has_many :demands, through: :artifact_demands

	has_many :forward_relationships, 	foreign_key: "origin_artifact_id", 
																		class_name: "Relationship",
																		dependent: :destroy,
																		autosave: true

	has_many :backward_relationships,	foreign_key: "end_artifact_id",
																		class_name: "Relationship",
																		dependent: :destroy,
																		autosave: true

	def code_with_name
		"#{code} - #{name}"
	end


end
