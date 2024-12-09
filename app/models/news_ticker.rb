class NewsTicker < ApplicationRecord
  belongs_to :admin, class_name: 'User'

  default_scope { where(deleted_at: nil) }

  enum status: { inactive: 0, active: 1 }

  validates :status, presence: true
  validates :content, presence: true

  def destroy
    update(deleted_at: Time.current)
  end
end