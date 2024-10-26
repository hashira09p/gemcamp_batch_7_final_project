# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      ## Devise Fields
      t.string :email, null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Additional Fields
      t.string :username, null: false, default: ""
      t.string :phone_number
      t.integer :coins, default: 0
      t.decimal :total_deposit, precision: 10, scale: 2, default: 0.0
      t.integer :children_members, default: 0

      t.datetime :remember_created_at

      t.timestamps null: false
    end

    add_index :users, :email, unique: true
    add_index :users, :username, unique: true
  end
end
