class CreateProjectsUsers < ActiveRecord::Migration[5.1]
  def change
  	create_table :projects_users do |t|
  		t.references :project, foreign_key: true, null: false
  		t.references :user, foreign_key: true, null: false
  	end

  	add_index :projects_users, [:project_id, :user_id], unique: true
  end
end
