class AddMemberLevelToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :member_level, default: 1
  end
end
