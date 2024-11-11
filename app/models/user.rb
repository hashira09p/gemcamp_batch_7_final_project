class User < ApplicationRecord
  enum role: { client: 0, admin: 1 }
  has_many :children, class_name: 'User', foreign_key: "parent_id", dependent: :destroy, counter_cache: :children_members
  belongs_to :parent, class_name: 'User', optional: true, counter_cache: :children_members
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  mount_uploader :image, ImageUploader
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

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

=begin
  private

  def increment_client_parent_children_members
    return unless parent.present? && parent.client?

    parent.increment!(:children_members)
  end

  def decrement_client_parent_children_members
    return unless parent.present? && parent.client?

    parent.decrement!(:children_members)
  end
=end
end
