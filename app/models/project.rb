class Project < ApplicationRecord
	validates :name, presence: true, uniqueness: true

	belongs_to :user_create, foreign_key: "user_create_id", class_name: "User"
	has_and_belongs_to_many :users
	has_many :demands, dependent: :destroy
end
