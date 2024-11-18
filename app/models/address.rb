class Address < ApplicationRecord
  belongs_to :user
  belongs_to :address_region, class_name: 'Address::Region'
  belongs_to :address_province, class_name: 'Address::Province'
  belongs_to :address_city, class_name: 'Address::City'
  belongs_to :address_barangay, class_name: 'Address::Barangay'

  enum genre: { home: 0, office: 1 }

  validates :phone_number, presence: true, numericality: { only_integer: true }, length: { is: 11}
  validates :name, presence: true
  validates :street_address, presence: true
  validates :remark, presence: true
  validates :address_region_id, presence: true
  validates :address_province_id, presence: true
  validates :address_city_id, presence: true
  validates :address_barangay_id, presence: true

  before_save :unset_other_default, if: :is_default?

  private

  def unset_other_default
    self.class.where(is_default: true, user_id: user_id).update_all(is_default: false)
  end
end