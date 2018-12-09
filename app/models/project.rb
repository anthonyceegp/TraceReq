class Project < ApplicationRecord
	validates :name, presence: true, uniqueness: { case_sensitive: false }
	validates :description, length: { maximum: 255}

	belongs_to :user
	has_and_belongs_to_many :users, -> { where(deleted_at: nil) }, dependent: :destroy

	has_many :artifact_types, dependent: :destroy
	has_many :artifact_statuses, dependent: :destroy
	has_many :artifacts, dependent: :destroy
	has_many :relationship_types, dependent: :destroy
	has_many :relationships, dependent: :destroy
	has_many :demands, dependent: :destroy

	def self.search(term)
		if !term.blank?
			where('name ILIKE ? OR description ILIKE ?', "%#{term}%", "%#{term}%").order(:name)
		else
			order(:name)
		end
	end
end
