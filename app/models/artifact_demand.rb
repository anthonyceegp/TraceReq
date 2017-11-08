class ArtifactDemand < ApplicationRecord
	belongs_to :artifact
	belongs_to :demand
	belongs_to :user
end
