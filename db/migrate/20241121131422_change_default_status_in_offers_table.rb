class ChangeDefaultStatusInOffersTable < ActiveRecord::Migration[7.0]
  def change
    change_column_default :offers, :status, 1
  end
end
