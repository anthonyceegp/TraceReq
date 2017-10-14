class AddUserCreateToRelationships < ActiveRecord::Migration[5.1]
  def change
    add_reference :relationships, :user_create, foreign_key: {to_table: :users}, null: false
  end
end
