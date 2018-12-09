class AddIndexOnColorAndProjectIdToRelationshipTypes < ActiveRecord::Migration[5.1]
  def change
  	add_index :relationship_types, [:color, :project_id]
  end
end
