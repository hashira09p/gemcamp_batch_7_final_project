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

  has_many :item_category_ships, dependent: :restrict_with_error
  has_many :categories, through: :item_category_ships

  def destroy
    update(deleted_at: Time.current)
  end

  aasm column: :state do
    state :pending, initial: true
    state :starting
    state :paused
    state :ended
    state :cancelled

    event :start do
      transitions from: [:pending, :paused, :cancelled], to: :starting,
      guard: :can_start?, after: :update_quantity_and_batch_count
    end

    event :pause do
      transitions from: :starting, to: :paused
    end

    event :end do
      transitions from: :starting, to: :end
    end

    event :cancel do
      transitions from: [:starting, :paused], to: :cancelled
    end

  end

  private

  def update_quantity_and_batch_count
    update(quantity: quantity - 1, batch_count: batch_count + 1)
  end

  def can_start?
    quantity.positive? && Date.today < offline_at && status == 'active'
    errors.add(:base, :item, message: "Doesn't meet requirements")
  end
end
