class ArtifactType < ApplicationRecord
	validates :name, presence: true, uniqueness: true

	belongs_to :project
	
	has_many :artifacts, dependent: :destroy
end
