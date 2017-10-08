class CreateRelationships < ActiveRecord::Migration[5.1]
  def change
    create_table :relationships do |t|
      t.bigint :origin_artifact_id
      t.bigint :end_artifact_id
      t.references :relationship_type, foreign_key: true
      t.string :description

      t.timestamps
    end
    add_foreign_key :relationships, :artifacts, column: :origin_artifact_id
    add_foreign_key :relationships, :artifacts, column: :end_artifact_id
  end
end
