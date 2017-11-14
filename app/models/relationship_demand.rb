class RelationshipDemand < ApplicationRecord
	belongs_to :relationship
	belongs_to :demand
	belongs_to :user

	enum status: [:created, :imported]

	def version
		self.relationship.versions[self.version_index]
	end
end
