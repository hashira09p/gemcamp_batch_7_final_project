class ChangeDefaultStatusInItemsTable < ActiveRecord::Migration[7.0]
  def change
    change_column_default :items, :status, 1
  end
end
