class AddStatusAndVersionIndexToRelationshipDemands < ActiveRecord::Migration[5.1]
  def change
    add_column :relationship_demands, :status, :integer, null: false
    add_column :relationship_demands, :version_index, :integer, null: false
  end
end
