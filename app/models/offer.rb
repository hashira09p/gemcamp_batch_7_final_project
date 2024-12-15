class Offer < ApplicationRecord
  mount_uploader :image, ImageUploader
  enum status: { inactive: 0, active: 1 }
  enum genre: { one_time: 1, monthly: 2, weekly: 3, daily: 4, regular: 5 }
  validates :name, :amount, :coin, :status, presence: true
  validates :name, uniqueness: true

  has_many :orders, -> { where(genre: :deposit) }
end
