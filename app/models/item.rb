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
      transitions guard: :can_start?, from: [:pending, :paused, :cancelled, :ended], to: :starting,
                  after: :update_quantity_and_batch_count
    end

    event :pause do
      transitions from: :starting, to: :paused
    end

    event :end do
      transitions guard: :batch_count_check?, from: :starting, to: :ended,
                  after: :winner
    end

    event :cancel do
      transitions from: [:starting, :paused, :pending], to: :cancelled, after: :ticket_cancel
    end
  end

  def percentage
    floor((value/minimum_tickets) * 100)
  end

  private

  def winner
    winner = tickets.where(state: 'pending').sample
    if winner.may_win?
      winner.win!
      address = winner.user.addresses.find_by(is_default: true)
      winner = Winner.new(item_id: winner.item_id, ticket_id: winner.id, user_id: winner.user_id, address_id: address.id,
                          item_batch_count: winner.batch_count)
      winner.save

      tickets = self.tickets.where(state: 'pending')

      tickets.each do |ticket|
        ticket.lose!
      end
    end
  end

  def batch_count_check?
    self.tickets.where(state: 'pending').count >= self.minimum_tickets
  end

  def update_quantity_and_batch_count
    self.update(quantity: quantity - 1, batch_count: batch_count + 1)
  end

  def can_start?
    if quantity > 0 && Date.today < offline_at && status == 'active'
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
        ticket.destroy
        ticket.save
      end
    end
  end
end
