class CreateNewsTickers < ActiveRecord::Migration[7.0]
  def change
    create_table :news_tickers do |t|
      t.text :content
      t.integer :status, default: 0
      t.references :admin, null: false, foreign_key: { to_table: :users }
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
