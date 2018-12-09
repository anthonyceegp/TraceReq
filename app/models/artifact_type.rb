class ArtifactType < ApplicationRecord
	validates :name, presence: true, uniqueness: { case_sensitive: false, scope: :project_id }

	belongs_to :project
	
	has_many :artifacts, dependent: :destroy
end
