class AddIndexOnNameAndProjectIdToArtifactTypes < ActiveRecord::Migration[5.1]
  def change
  	add_index :artifact_types, [:name, :project_id]
  end
end
