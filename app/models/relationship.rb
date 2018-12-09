class Relationship < ApplicationRecord
  validates :description, length: { maximum: 255}

  validate :uniqueness_in_both_ways, if: 'origin_artifact.present? and end_artifact.present?'
  validate :equal_artifacts, if: 'origin_artifact.present? and end_artifact.present?'

  validates_uniqueness_of :origin_artifact, scope: [:end_artifact_id], 
  						                    message: 'already related to end artifact.',
  						                    before: [:create, :update]
  validates_uniqueness_of :end_artifact, scope: [:origin_artifact_id],
                                  message: 'already related to origin artifact.',
                                  before: [:create, :update]

  belongs_to :origin_artifact, class_name: 'Artifact'
  belongs_to :end_artifact, class_name: 'Artifact'
  belongs_to :relationship_type
  belongs_to :user
  belongs_to :project

  def type
    relationship_type.name
  end

  def self.matrix(project, demand, filter)
    Matrix.new(project, demand, filter)
  end

  private

  def equal_artifacts
    if origin_artifact_id == end_artifact_id
      errors.add(:origin_artifact, 'must be different from end artifact.')
      errors.add(:end_artifact, 'must be different from origin artifact.')
    end
  end

  def uniqueness_in_both_ways
    if Relationship.where(origin_artifact: end_artifact, end_artifact: origin_artifact).any?
      errors.add(:origin_artifact, 'already related to end artifact.')
      errors.add(:end_artifact, 'already related to origin artifact.')
    end
  end
end
