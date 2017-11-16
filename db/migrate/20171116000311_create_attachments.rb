class CreateAttachments < ActiveRecord::Migration[5.1]
  def change
    create_table :attachments do |t|
    	t.references :artifact, foreign_key: true, null: false
    	t.integer :artifact_version_index, null: false

      t.timestamps
    end
  end
end
