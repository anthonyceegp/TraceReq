class CreateProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :projects do |t|
      t.string :name, null: false, index: { unique: true }
      t.string :description
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
