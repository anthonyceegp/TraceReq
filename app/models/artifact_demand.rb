class ArtifactDemand < ApplicationRecord
	belongs_to :artifact
	belongs_to :demand
end
