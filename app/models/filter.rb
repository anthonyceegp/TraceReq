class Filter
	extend ActiveModel::Naming

	attr_reader :show_all, :demand_id, :column_artifact_type_id, :row_artifact_type_id, :relationship_type_id

	def initialize(params)
		if !params.nil?
			@show_all = params["show_all"]
			@demand_id = params["demand_id"]
			@column_artifact_type_id = params["column_artifact_type_id"]
			@row_artifact_type_id = params["row_artifact_type_id"]
			@relationship_type_id = params["relationship_type_id"]
		end
	end

	def empty?
	  show_all.nil? || demand_id.nil? || column_artifact_type_id.nil? || row_artifact_type_id.nil? || relationship_type_id.nil?
	end
end