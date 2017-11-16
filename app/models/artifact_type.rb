class ArtifactType < ApplicationRecord
	validates :name, presence: true, uniqueness: { case_sensitive: false }

	belongs_to :project
	
	has_many :artifacts, dependent: :destroy
end
