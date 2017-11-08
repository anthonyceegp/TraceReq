class AddUserReferenceToRelationships < ActiveRecord::Migration[5.1]
  def change
    add_reference :relationships, :user, foreign_key: true, null: false
  end
end
