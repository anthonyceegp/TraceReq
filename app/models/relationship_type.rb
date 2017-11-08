class RelationshipType < ApplicationRecord
	validates :name, presence: true, uniqueness: true

	belongs_to :project

	has_many :relationships, dependent: :destroy
end
