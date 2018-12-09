class Template < ApplicationRecord
	enum model: [:project, :demand]

  validates_presence_of :content
  validates :model, presence: true, uniqueness: { scope: :project, case_sensitive: false }, inclusion: { in: models.keys }
  validates :name, presence: true, uniqueness: { scope: :project, case_sensitive: false }

  belongs_to :project
  belongs_to :user
end
