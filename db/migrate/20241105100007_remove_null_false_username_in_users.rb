class RemoveNullFalseUsernameInUsers < ActiveRecord::Migration[7.0]
  def up
    change_column :users, :username, :string, null: true
  end

  def down
    change_column :users, :username, :string, null: false
  end
end
