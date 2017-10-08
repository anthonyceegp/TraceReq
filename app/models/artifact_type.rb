class ArtifactType < ApplicationRecord
	validates :name, presence: true, uniqueness:true

	has_many :artifacts, dependent: :destroy
end
