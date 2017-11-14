class Relationship < ApplicationRecord
  has_paper_trail meta: { origin_artifact_id: :origin_artifact_id }

  before_create { touch_origin_artifact('create relationship') }
  before_update { touch_origin_artifact('update relationship') }
  before_destroy { touch_origin_artifact('destroy relationship') }

  validates :origin_artifact_id, presence: true
  validates :end_artifact_id, presence: true
  validates :relationship_type_id, presence: true

  validate :equal_artifacts
  validate :uniqueness_in_both_ways

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
  
  has_many :relationship_demands, dependent: :destroy
  has_many :demands, through: :relationship_demands

  def equal_artifacts
  	if origin_artifact_id == end_artifact_id
      errors.add(:artifact, 'must be different from end artifact.')
      errors.add(:end_artifact, 'must be different from origin artifact.')
    end
  end

  def uniqueness_in_both_ways
    if Relationship.where(origin_artifact: end_artifact, end_artifact: origin_artifact).any?
      errors.add(:origin_artifact, 'already related to end artifact.')
      errors.add(:end_artifact, 'already related to origin artifact.')
    end
  end

  def touch_origin_artifact(event)
    origin_artifact.paper_trail_event = event
    origin_artifact.paper_trail.touch_with_version
    origin_artifact.paper_trail_event = nil
  end
end
