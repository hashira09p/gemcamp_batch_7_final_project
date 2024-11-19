class Ticket < ApplicationRecord
  include AASM

  has_many :winners

  belongs_to :item
  belongs_to :user

  before_create :set_serial_number
  after_create :deduct_coin

  aasm column: :state do
    state :pending, initial: true
    state :won
    state :lost
    state :cancelled

    event :win do
        transitions from: :pending, to: :won
    end

    event :lose do
      transitions from: :pending, to: :lost
    end

    event :cancel do
      transitions from: :pending, to: :cancelled
    end
  end

  private

  def deduct_coin
    user.coins -= 1
    user.save
  end

  def set_serial_number
    ticket_count = Ticket.where(item: item).count + 1
    self.serial_number = generate_serial_number(ticket_count)
  end

  def generate_serial_number(number_count)
    date_part = Time.current.strftime('%y%m%d')
    "#{date_part}-#{item.id}-#{item.batch_count}-#{number_count.to_s.rjust(4, '0')}"
  end
end