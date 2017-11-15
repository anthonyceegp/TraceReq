class Artifact < ApplicationRecord
	has_paper_trail on: [:create, :update]

	before_destroy do 
		self.versions.destroy_all
	end

	after_destroy do
		Relationship.paper_trail.disable
		PaperTrail::Version.where(origin_artifact_id: self.id).destroy_all
		Relationship.paper_trail.enable
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
		[code, name].join(' - ')
	end

	def version_index
		versions.last.index
	end

	def revert_to(version_indexx)
		Artifact.transaction do
			version = versions[version_indexx]
	    previous_version = version.previous
	    artifact = version.reify(has_many: true, mark_for_destruction: true)
	    artifact.save!
	    # Destroy all versions of artifacts and relationships dated after the artifact version that has been reified
	    PaperTrail::Version.where(item_type: "Relationship", origin_artifact_id: version.item_id)
	                       .where("created_at > ?", previous_version.created_at).destroy_all
	    versions.where("created_at > ?", previous_version.created_at).destroy_all
	    # Set all version_indexes higher than the last remaining version
	    artifact_demands.where("version_index > ?", previous_version.index).update_all(version_index: previous_version.index)
	  end
	end
end
