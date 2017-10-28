class Demand < ApplicationRecord
	validates :name, presence: true, uniqueness: true
	validates :project_id, presence: true
	validates :status, presence: true

	enum status: [:to_do, :analayzing, :to_devolpment, :developing, :to_test, :testing, :to_homologate, :done, :canceled]

	belongs_to :user_create, foreign_key: "user_create_id", class_name: "User"
	has_and_belongs_to_many :users
	belongs_to :project

	has_many :artifact_demands
	has_many :artifacts, through: :artifact_demands

	has_many :relationship_demands
 	has_many :relationships, through: :relationship_demands
end