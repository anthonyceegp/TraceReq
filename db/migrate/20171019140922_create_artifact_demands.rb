class CreateArtifactDemands < ActiveRecord::Migration[5.1]
  def change
    create_table :artifact_demands do |t|
  		t.references :artifact, foreign_key: true, null: false
  		t.references :demand, foreign_key: true, null: false
  		t.references :user, foreign_key: true, null: false
      t.integer :version_index, null: false
      t.integer :status, null: false

  		t.timestamps
  	end

  	add_index :artifact_demands, [:artifact_id, :demand_id], unique: true
  end
end
