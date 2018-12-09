class ArtifactDemand < ApplicationRecord
	belongs_to :artifact
	belongs_to :demand
	belongs_to :user

	enum status: [:created, :imported]

	def version
		artifact.versions[version_index]
	end

	def edited?
		artifact.version_index > version_index
	end
end
