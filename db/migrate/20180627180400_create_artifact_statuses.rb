class CreateArtifactStatuses < ActiveRecord::Migration[5.1]
  def change
    create_table :artifact_statuses do |t|
      t.string :name, null: false
      t.references :project, foreign_key: true, null: false

      t.timestamps
    end

    add_index :artifact_statuses, [:name, :project_id], unique: true
  end
end
