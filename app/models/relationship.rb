class Relationship < ApplicationRecord
  validates :origin_artifact_id, presence: true
  validates :end_artifact_id, presence: true
  validates :relationship_type_id, presence: true

  validate :equalArtifacts

  validates_uniqueness_of :origin_artifact, scope: [:end_artifact_id], 
  						                    message: "is already related to end artifact", 
  						                    before: [:create, :update]

  belongs_to :origin_artifact, class_name: "Artifact"
  belongs_to :end_artifact, class_name: "Artifact"
  belongs_to :relationship_type
  belongs_to :user
  
  has_many :relationship_demands, dependent: :destroy
  has_many :demands, through: :relationship_demands

  def equalArtifacts
  	errors.add(:end_artifact_id, "must be different from origin artifact.") if origin_artifact_id == end_artifact_id
  end

  def self.getCodes
    return [self.getOrigin.code, self.getEnd.code]
  end

  def self.getOrigin
    return origin_artifact
  end

  def self.getEnd
    return end_artifact
  end
end
