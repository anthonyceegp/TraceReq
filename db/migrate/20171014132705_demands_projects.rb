class DemandsProjects < ActiveRecord::Migration[5.1]
  def change
  	create_table :demands_projects do |t|
  		t.references :demand, foreign_key: true, null: false
  		t.references :project, foreign_key: true, null: false  		
  	end
  	add_index :demands_projects, [:demand_id, :project_id], unique: true
  end
end
