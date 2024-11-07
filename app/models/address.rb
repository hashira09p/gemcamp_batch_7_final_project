class Address < ApplicationRecord
  belongs_to :user
  belongs_to :address_region, class_name: 'Address::Region'
  belongs_to :address_province, class_name: 'Address::Province'
  belongs_to :address_city, class_name: 'Address::City'
  belongs_to :address_barangay, class_name: 'Address::Barangay'

  enum genre: { home: 0, office: 1 }
end