class AddSortToCategories < ActiveRecord::Migration[7.0]
  def change
    add_column :categories, :sort, :integer, default: 1
  end
end
