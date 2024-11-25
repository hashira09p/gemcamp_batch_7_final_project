class Ticket < ApplicationRecord
  include AASM

  has_many :winners

  belongs_to :item
  belongs_to :user

  before_create  :check_coin_user
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
      transitions from: :pending, to: :cancelled, after: :refund_coins
    end

  end

  private

  def check_coin_user
    if user.coins < coins
      errors.add(:base, "Insufficient coins")
      throw(:abort)
    end
  end

  def deduct_coin
    user.coins -= 1
    user.save
  end

  def set_serial_number
    ticket_count = Ticket.where(state: 'pending').count + 1
    self.serial_number = generate_serial_number(ticket_count)
  end

  def generate_serial_number(number_count)
    date_part = Time.current.strftime('%y%m%d')
    "#{date_part}-#{item.id}-#{item.batch_count}-#{number_count.to_s.rjust(4, '0')}"
  end

  def refund_coins
    user.coins += 1
    user.save
  end
end