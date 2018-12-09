class AddIndexOnNameAndProjectIdToRelationshipTypes < ActiveRecord::Migration[5.1]
  def change
  	add_index :relationship_types, [:name, :project_id]
  end
end
