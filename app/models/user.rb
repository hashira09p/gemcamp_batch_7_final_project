class User < ApplicationRecord
  mount_uploader :image, ImageUploader

  enum role: { client: 0, admin: 1 }
  has_many :children, class_name: 'User', foreign_key: "parent_id", dependent: :destroy, counter_cache: :children_members
  belongs_to :parent, class_name: 'User', optional: true, counter_cache: :children_members
  belongs_to :member_level
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :phone_number, phone: {
       possible: true,
       allow_blank: true,
       types: %i[voip mobile],
       countries: [:ph]
  }

  validates :username, uniqueness: true, allow_blank: true
  validates :coins, numericality: { greater_than_or_equal_to: 0 }

  has_many :addresses
  has_many :address_regions, through: :addresses
  has_many :address_provinces, through: :addresses
  has_many :address_cities, through: :addresses
  has_many :address_barangays, through: :addresses
  has_many :tickets
  has_many :winners
  has_many :orders
  has_many :news_tickers, dependent: :destroy

  after_create :check_parent_for_upgrade

  private

  def check_parent_for_upgrade
    return unless parent

    current_level = parent.member_level
    return unless current_level

    if parent.children.count >= current_level.required_members
      next_level = MemberLevel.find_by(level: current_level.level + 1)
      if next_level
        parent.update!(member_level: next_level)
        parent.update!(coins: parent.coins.to_i + next_level.coins)
        Order.create(user: parent, member_level: next_level)
      end
    end
  end
end