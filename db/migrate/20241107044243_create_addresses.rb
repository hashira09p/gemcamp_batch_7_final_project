class CreateAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.integer :genre,  default: 0 # for enum home/office
      t.string :name, null: false
      t.string :street_address, null: false
      t.string :phone_number, null: false
      t.string :remark
      t.boolean :is_default, default: false
      t.references :user
      t.references :address_region
      t.references :address_province
      t.references :address_city
      t.references :address_barangay

      t.timestamps
    end
  end
end
