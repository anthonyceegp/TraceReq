class CreateRelationshipDemands < ActiveRecord::Migration[5.1]
	def change
		create_table :relationship_demands do |t|
			t.references :relationship, foreign_key: true, null: false
			t.references :demand, foreign_key: true, null: false
			t.references :user, foreign_key: true, null: false

			t.timestamps
		end

		add_index :relationship_demands, [:relationship_id, :demand_id], unique: true
	end
end
