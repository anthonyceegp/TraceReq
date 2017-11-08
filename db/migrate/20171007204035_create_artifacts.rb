class CreateArtifacts < ActiveRecord::Migration[5.1]
  def change
    create_table :artifacts do |t|
      t.string :code, null: false, index: { unique: true }
      t.string :name, null: false
      t.string :description
      t.string :priority
      t.references :artifact_type, foreign_key: true, null: false
      t.attachment :file

      t.timestamps
    end
  end
end
