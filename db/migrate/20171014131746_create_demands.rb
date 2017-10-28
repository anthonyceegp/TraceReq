class CreateDemands < ActiveRecord::Migration[5.1]
  def change
    create_table :demands do |t|
      t.string :name, null: false, index: { unique: true }
      t.string :description
      t.integer :status, default: 0, null: false
      t.string :release
      t.references :user_create, foreign_key: {to_table: :users}, null: false
      t.references :project, foreign_key: true, null: false

      t.timestamps
    end
  end
end
