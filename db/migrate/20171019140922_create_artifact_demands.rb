class CreateArtifactDemands < ActiveRecord::Migration[5.1]
  def change
    create_table :artifact_demands do |t|
  		t.references :artifact, foreign_key: true, null: false
  		t.references :demand, foreign_key: true, null: false
  		t.references :user_included, foreign_key: {to_table: :users}, null: false

  		t.timestamps
  	end

  	add_index :artifact_demands, [:artifact_id, :demand_id], unique: true
  end
end
