class AddCodeAndProjectIdIndexToArtifact < ActiveRecord::Migration[5.1]
  def change
  	add_index :artifacts, [:code, :project_id]
  end
end
