class RelationshipDemand < ApplicationRecord
	belongs_to :relationship
	belongs_to :demand
	belongs_to :user
end
