class Demand < ApplicationRecord
	validates :name, presence: true, uniqueness: true
	validates :project_id, presence: true
	validates :status, presence: true
	validates :responsible_user_id, presence: true

	enum status: [:to_do, :analayzing, :to_devolpment, :developing, :to_test, :testing, :to_homologate, :done, :canceled]

	belongs_to :responsible_user, class_name: "User"
	belongs_to :project

	has_many :artifact_demands, dependent: :destroy
	has_many :artifacts, through: :artifact_demands

	has_many :relationship_demands
 	has_many :relationships, through: :relationship_demands

 	def edited_artifacts
 		result = []
 		artifacts.each do |artifact|
 			result << artifact  if artifact.version_index > artifact_demands.where(artifact_id: artifact.id).first.version_index
 		end
 		return result
 	end
end