class ArtifactStatus < ApplicationRecord
	validates :name, presence: true, uniqueness: { case_sensitive: false, scope: :project_id }

	belongs_to :project
		
	has_many :artifacts, dependent: :destroy
	has_many :chart_data, dependent: :destroy
end
