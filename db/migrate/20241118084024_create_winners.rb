class CreateWinners < ActiveRecord::Migration[7.0]
  def change
    create_table :winners do |t|
      t.references :item_id
      t.references :ticket_id
      t.references :user_id
      t.references :address_id
      t.integer :item_batch_count
      t.string :state
      t.integer :price
      t.datetime :paid_at
      t.references :admin_id
      t.string :picture
      t.string :comment
      t.timestamps
    end
  end
end
