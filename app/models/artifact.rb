class Artifact < ApplicationRecord
	validates :code, presence: true, uniqueness: true, length: { maximum: 6}
	validates :name, presence: true
	validates :description, length: { maximum: 255}
	validates :artifact_type_id, presence: true

	belongs_to :artifact_type

	def code_with_name
		"#{code} - #{name}"
	end
end
