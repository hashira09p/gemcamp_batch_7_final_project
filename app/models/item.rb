class Item < ApplicationRecord
  include AASM
  mount_uploader :image, ImageUploader
  enum status: { active: 0, inactive: 1 }
  default_scope { where(deleted_at: nil) }

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :minimum_tickets, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :batch_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :start_at, :online_at, :offline_at, :status, :name, :image, presence: true

  has_many :item_category_ships, dependent: :restrict_with_error
  has_many :categories, through: :item_category_ships
  has_many :tickets, dependent: :restrict_with_error
  has_many :winners

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
      transitions guard: :can_start?, from: [:pending, :paused, :cancelled, :ended], to: :starting
    end

    event :pause do
      transitions from: :starting, to: :paused
    end

    event :end do
      transitions guard: :batch_count_check?, from: :starting, to: :ended,
                  after: :update_quantity_and_batch_count
    end

    event :cancel do
      transitions from: [:starting, :paused, :pending], to: :cancelled, after: [:ticket_cancel, :refund_coin]
    end
  end

  private

  def batch_count_check?
    if self.batch_count >= self.minimum_tickets
      true
    else
      false
    end
  end

  def refund_coin
    user_tickets = tickets
    user_tickets.each do |user_ticket|
      user_ticket.user.coins += 1
      user_ticket.user.save
      ticket.destroy
    end
  end

  def update_quantity_and_batch_count
    self.update(quantity: quantity - 1, batch_count: batch_count + 1)
  end

  def can_start?
    if quantity.positive? && Date.today < offline_at && status == 'active'
      true
    else
      errors.add(:base, :item, message: "Doesn't meet requirements")
      false
    end
  end

  def ticket_cancel
    tickets = Ticket.includes(:item).where(item: self, state: :pending, batch_count: self.batch_count)

    tickets.each do |ticket|
      if ticket.may_cancel?
        ticket.cancel!
      end
    end
  end
end
