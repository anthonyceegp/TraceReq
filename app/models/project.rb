class Project < ApplicationRecord
	validates :name, presence: true, uniqueness: true

	belongs_to :user
	has_and_belongs_to_many :users, dependent: :destroy

	has_many :demands, dependent: :destroy
	has_many :artifacts, dependent: :destroy
end
