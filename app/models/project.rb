class Project < ApplicationRecord
	validates :name, presence: true, uniqueness: true

	belongs_to :user
	has_and_belongs_to_many :users, dependent: :destroy

	has_many :artifact_types, dependent: :destroy
	has_many :relationship_types, dependent: :destroy
	has_many :demands, dependent: :destroy
	has_many :artifacts, dependent: :destroy
end
