class AddSortToBanners < ActiveRecord::Migration[7.0]
  def change
    add_column :banners, :sort, :integer, default: 1
  end
end
