class CreateTemplates < ActiveRecord::Migration[5.1]
  def change
    create_table :templates do |t|
      t.string :name, null: false
      t.references :project, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false
      t.integer :model, null: false
      t.text :content, null: false

      t.timestamps
    end
    add_index :templates, [:project_id, :model], unique: true
    add_index :templates, [:project_id, :name], unique: true
  end
end
