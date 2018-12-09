class Artifact < ApplicationRecord
	has_paper_trail on: [:create, :update]

	before_destroy do 
		self.versions.destroy_all
	end

	after_create do
		self.chart_data.build(artifact_status: self.artifact_status)
	end

	before_update do		
			self.chart_data.build(artifact_status: self.artifact_status) if self.artifact_status_id_changed?
	end

	validates :code, presence: true, uniqueness: { case_sensitive: false, scope: :project_id }, length: { maximum: 6}
	validates :name, presence: true
	validates :artifact_status, presence: true

	belongs_to :artifact_type
	belongs_to :artifact_status
	belongs_to :user
	belongs_to :project

	has_many :attachments, dependent: :destroy
	has_many :comments, dependent: :destroy
	has_many :artifact_demands, dependent: :destroy
	has_many :demands, through: :artifact_demands
	has_many :chart_data, dependent: :destroy

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

	def type
		artifact_type.name
	end

	def status
		artifact_status.name
	end

	def conflict?
		demands.size > 1
	end

	def version_index
		versions.last.index
	end

	def history
		versions[1..version_index].sort_by{ |e| -e[:id] }
	end

	def revert_to(index)
		Artifact.transaction do
			version = versions[index]
	    previous_version = version.previous
	    artifact = version.reify
	    artifact.save!
	    # Delete files uploaded before restored version
	    attachments.where('artifact_version_index > ?', previous_version.index).destroy_all
	    # Destroy all versions of artifacts created after the artifact version that has been reified
	    versions.where("created_at > ?", previous_version.created_at).destroy_all
	    # Set all version_indexes higher than the last remaining version
	    artifact_demands.where("version_index > ?", previous_version.index).update_all(version_index: previous_version.index)
	  end
	end

	def attachment
		attachments.find(attachment_id) unless attachment_id.nil?
	end

	def self.search(term)
		if !term.blank?
			where("code ILIKE ? OR name ILIKE ? OR description ILIKE ? OR artifact_status_id = ?", "%#{term}%", "%#{term}%", "%#{term}%", ArtifactStatus.where('name ILIKE ?', "%#{term}%").pluck(:id).first).order(:name)
		else
			order(:name)
		end
	end
end
