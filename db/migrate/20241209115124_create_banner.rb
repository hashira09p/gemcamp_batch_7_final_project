class CreateBanner < ActiveRecord::Migration[7.0]
  def change
    create_table :banners do |t|
      t.string :preview
      t.integer :status, default: 0
      t.datetime :online_at
      t.datetime :offline_at
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
