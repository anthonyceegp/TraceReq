class Relationship < ApplicationRecord
  validates :origin_artifact, presence: true
  validates :end_artifact, presence: true
  validate :artifacts_cannot_be_equal

  belongs_to :origin_artifact, class_name: "Artifact"
  belongs_to :end_artifact, class_name: "Artifact"
  belongs_to :relationship_type

  def artifacts_cannot_be_equal
  	errors.add(:end_artifact_id, "must be different from origin artifact.") if origin_artifact_id == end_artifact_id
  end
end
