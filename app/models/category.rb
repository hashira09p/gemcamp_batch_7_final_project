class Category < ApplicationRecord
  has_many :item_category_ships
  has_many :items, through: :item_category_ships, dependent: :restrict_with_error

  validates :sort, presence: true
  validates :name, uniqueness: true

  default_scope { where(deleted_at: nil) }

  def destroy
    update(deleted_at: Time.current)
  end
end
