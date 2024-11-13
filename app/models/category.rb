class Category < ApplicationRecord
  has_many :item_category_ships
  has_many :items, through: :item_category_ships, dependent: :restrict_with_error
end
