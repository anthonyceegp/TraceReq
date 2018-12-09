class Demand < ApplicationRecord
	validates :name, presence: true, uniqueness: { case_sensitive: false }
	validates :description, length: { maximum: 255}

	belongs_to :responsible_user, class_name: "User"
	belongs_to :project

	has_many :artifact_demands, dependent: :destroy
	has_many :artifacts, through: :artifact_demands

 	def conflicted_artifacts
 		artifacts.find_all{ |a| a.conflict? or artifact_demands.find_by(artifact: a).edited? }
 	end

 	def self.search(term)
		if !term.blank?
			where('name ILIKE ? OR description ILIKE ?', "%#{term}%", "%#{term}%").order(:name)
		else
			order(:name)
		end
	end

	def search_artifact_to_import(term)
		if !term.blank?
			Artifact.where.not(id: artifacts.ids)
			        .where('code ILIKE ? OR name ILIKE ? OR description ILIKE ?', "%#{term}%", "%#{term}%", "%#{term}%")
			        .order(:artifact_type_id, :code)
		else
    	Artifact.where.not(id: artifacts.ids).order(:artifact_type_id, :code)
		end
	end

	def destroy_created_artifacts
		artifact_demands.where(status: "created").each do |artifact_demand|
      artifact_demand.artifact.destroy
    end
  end
end