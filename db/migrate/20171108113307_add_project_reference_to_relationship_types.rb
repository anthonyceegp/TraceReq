class AddProjectReferenceToRelationshipTypes < ActiveRecord::Migration[5.1]
  def change
    add_reference :relationship_types, :project, foreign_key: true, null: false
  end
end
