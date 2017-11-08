class Demand < ApplicationRecord
	validates :name, presence: true, uniqueness: true
	validates :project_id, presence: true
	validates :status, presence: true

	enum status: [:to_do, :analayzing, :to_devolpment, :developing, :to_test, :testing, :to_homologate, :done, :canceled]

	belongs_to :user
	belongs_to :project

	has_many :artifact_demands, dependent: :destroy
	has_many :artifacts, through: :artifact_demands

	has_many :relationship_demands
 	has_many :relationships, through: :relationship_demands
end