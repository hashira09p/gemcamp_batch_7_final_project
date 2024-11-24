class AddColumnToTickets < ActiveRecord::Migration[7.0]
  def change
    add_column :tickets, :deleted_at, :datetime
  end
end
