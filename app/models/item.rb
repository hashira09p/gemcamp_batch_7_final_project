class Item < ApplicationRecord
  include AASM
  mount_uploader :image, ImageUploader
  enum status: {active: 0, inactive: 1}
  default_scope { where(deleted_at: nil) }

  validates :name, presence: true
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :minimum_tickets, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :batch_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :start_at, :online_at, :offline_at, :status, presence: true

  def destroy
    update(deleted_at: Time.current)
  end

  aasm column: :state do
    state :new, initial: true
    state :processed
    state :completed
    state :cancelled

    event :process do
      transitions from: :new, to: :processed
    end

    event :complete do
      transitions from: :processed, to: :completed
    end

    event :cancel do
      transitions from: [:new, :processed], to: :cancelled
    end
  end
end
