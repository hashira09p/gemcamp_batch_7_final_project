class RemoveClientIdFromMemberLevels < ActiveRecord::Migration[7.0]
  def change
    remove_column :member_levels, :client_id, :bigint
  end
end
