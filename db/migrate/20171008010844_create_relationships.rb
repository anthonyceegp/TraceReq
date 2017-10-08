class CreateRelationships < ActiveRecord::Migration[5.1]
  def change
    create_table :relationships do |t|
      t.references :origin_artifact, foreign_key: {to_table: :artifacts}, null: false
      t.references :end_artifact, foreign_key: {to_table: :artifacts},  null: false
      t.references :relationship_type, foreign_key: true, null:false
      t.string :description

      t.timestamps
    end
    add_index :relationships, [:origin_artifact_id, :end_artifact_id], unique: true
  end
end
