class CreateArtifacts < ActiveRecord::Migration[5.1]
  def change
    create_table :artifacts do |t|
      t.string :code, null: false, unique: true
      t.string :name, null: false
      t.text :description
      t.string :priority
      
      t.belongs_to :artifact_type, null: false, index: true

      t.timestamps
    end
  end
end
