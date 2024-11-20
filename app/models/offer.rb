class Offer < ApplicationRecord
  mount_uploader :image, ImageUploader
  enum status: { active: 0, inactive: 1 }
  validates :name, :amount, :coin, :status, presence: true

  has_many :orders
end
