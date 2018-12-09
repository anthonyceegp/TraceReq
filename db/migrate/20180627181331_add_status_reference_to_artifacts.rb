class AddStatusReferenceToArtifacts < ActiveRecord::Migration[5.1]
  def change
    add_reference :artifacts, :artifact_status, foreign_key: true, null: false
  end
end
