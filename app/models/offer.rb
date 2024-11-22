class Offer < ApplicationRecord
  mount_uploader :image, ImageUploader
  enum status: { inactive: 0, active: 1 }
  validates :name, :amount, :coin, :status, presence: true

  has_many :orders, -> { where(genre: :deposit) }
end
