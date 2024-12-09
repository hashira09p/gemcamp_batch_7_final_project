class Banner < ApplicationRecord
  mount_uploader :preview, ImageUploader

  enum status: {inactive: 0, active: 1}
  validates :preview, presence: true
  validates :status, presence: true
  validates :online_at, presence: true
  validates :offline_at, presence: true

  default_scope { where(deleted_at: nil) }

  before_save :check_date
  before_update :check_date

  def destroy
    update(deleted_at: Time.current)
  end

  private

  def check_date
    if online_at < offline_at
      true
    else
      errors.add(:base, "Check your input in online at and offline at")
      throw(:abort)
      false
    end
  end
end