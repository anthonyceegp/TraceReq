class RelationshipType < ApplicationRecord
	validates :name, presence: true, uniqueness: true

	has_many :relationships, dependent: :destroy
end
