class AddAttachmentIdColumnToArtifacts < ActiveRecord::Migration[5.1]
  def change
    add_column :artifacts, :attachment_id, :bigint
  end
end
