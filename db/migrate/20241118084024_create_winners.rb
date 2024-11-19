class CreateWinners < ActiveRecord::Migration[7.0]
  def change
    create_table :winners do |t|
      t.references :item
      t.references :ticket
      t.references :user
      t.references :address
      t.integer :item_batch_count
      t.string :state
      t.integer :price
      t.datetime :paid_at
      t.references :admin
      t.string :picture
      t.string :comment
      t.timestamps
    end
  end
end
