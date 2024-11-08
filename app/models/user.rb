class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  mount_uploader :image, ImageUploader
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { client: 0, admin: 1 }

  validates :phone_number, phone: {
       possible: true,
       allow_blank: true,
       types: %i[voip mobile],
       countries: [:ph]
  }

  validates :username, uniqueness: true, allow_blank: true

  has_many :addresses
  has_many :address_regions, through: :addresses
  has_many :address_provinces, through: :addresses
  has_many :address_cities, through: :addresses
  has_many :address_barangays, through: :addresses
end
