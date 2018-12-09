class AddColorColumnToRelationshipTypes < ActiveRecord::Migration[5.1]
  def change
    add_column :relationship_types, :color, :string, null: false
  end
end
