class RenameColumnInWinnersTable < ActiveRecord::Migration[7.0]
  def change
    rename_column :winners, :picture, :image
  end
end
