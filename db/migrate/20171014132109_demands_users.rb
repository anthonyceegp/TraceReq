class DemandsUsers < ActiveRecord::Migration[5.1]
  def change
  	create_table :demands_users do |t|
  		t.references :demand, foreign_key: true, null: false
  		t.references :user, foreign_key: true, null: false
  	end
  	
  	add_index :demands_users, [:demand_id, :user_id], unique: true
  end
end
