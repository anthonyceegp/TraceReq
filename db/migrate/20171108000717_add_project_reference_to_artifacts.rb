class AddProjectReferenceToArtifacts < ActiveRecord::Migration[5.1]
  def change
    add_reference :artifacts, :project, foreign_key: true, null: false
  end
end
