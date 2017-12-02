class AddUsernameToUsers < ActiveRecord::Migration[5.1]
  def self.up
    change_table :users do |t|
      t.string :username
    end
  end

  def self.down
    remove_column :users, :username
  end
end
