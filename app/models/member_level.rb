class MemberLevel < ApplicationRecord
  has_many :client, class_name: 'User'
end