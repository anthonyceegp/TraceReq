class AddProjectReferenceToRelationships < ActiveRecord::Migration[5.1]
  def change
    add_reference :relationships, :project, foreign_key: true, null: false
  end
end
