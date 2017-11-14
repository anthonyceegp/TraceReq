class AddOriginArtifactIdToVersions < ActiveRecord::Migration[5.1]
  def change
    add_column :versions, :origin_artifact_id, :integer
  end
end
