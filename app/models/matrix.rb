class Matrix

  def initialize(project, demand, filter)
    @project = project
    @demand = demand
    @filter = filter
  end

  def rows
		query_rows.distinct.order(:artifact_type_id, :code)
  end

  def columns
  	query_columns.distinct.order(:artifact_type_id, :code)
  end

  def relationships
  	Relationship.where(origin_artifact_id: query_rows.ids).distinct
  end

  private

  def query_rows
    result = @demand.nil? ? @project.artifacts : @demand.artifacts
    result = @project.artifacts if @filter.show_all == "1"
    result = Demand.find(@filter.demand_id).artifacts unless @filter.demand_id.blank?
    result = result.where(artifact_type_id: @filter.row_artifact_type_id) unless @filter.row_artifact_type_id.blank?
    result = result.joins('inner join relationships on relationships.origin_artifact_id = artifacts.id')
                   .where('relationships.relationship_type_id = ?', @filter.relationship_type_id) unless @filter.relationship_type_id.blank?

    return result
  end

  def query_columns
    result = @demand.nil? ? @project.artifacts : @demand.artifacts
    result = @project.artifacts if @filter.show_all == "1"
    result = Demand.find(@filter.demand_id).artifacts unless @filter.demand_id.blank?
    result = result.where(artifact_type_id: @filter.column_artifact_type_id) unless @filter.column_artifact_type_id.blank?
    result = result.joins('inner join relationships on relationships.end_artifact_id = artifacts.id')
                   .where('relationships.relationship_type_id = ?', @filter.relationship_type_id) unless @filter.relationship_type_id.blank?

    return result
  end
end