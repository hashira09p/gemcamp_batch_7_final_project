class Order < ApplicationRecord
  include AASM
  enum genre: { deposit: 0, increase: 1, deduct: 2, bonus: 3, share: 4 }

  belongs_to :user
  belongs_to :offer

  before_create :generate_serial_number

  validates :amount, presence: true, numericality: { greater_than: 0 }, if: :deposit?
  validates :coin, presence: true, numericality: { greater_than: 0 }, if: :deposit?

  aasm column: :state do
    state :pending, initial: true
    state :submitted
    state :cancelled
    state :paid

    event :submit do
      transitions from: :pending, to: :submitted
    end

    event :cancel do
      transitions guard: :check_user_coins, from: [:pending, :submitted, :paid], to: :cancelled,
                  after: :user_coins_manipulate_for_cancelled
    end

    event :pay do
      transitions from: :submitted, to: :paid, after: :user_coins_manipulate_for_paid
    end
  end

  private

  def user_coins_manipulate_for_paid
    if !deduct?
      user.coins -= 1
    else
      user.coins += 1
    end
    user.total_deposit += 1 if deposit?
    user.save
  end

  def user_coins_manipulate_for_cancelled
    if deduct?
      user.coins += 1
    else
      user.coins -= 1
    end
    user.total_deposit -= 1 if deposit?
    user.save
  end

  def check_user_coins
    user.coins > 0
  end

  def generate_serial_number
    total_user_orders = user.orders.count + 1
    formatted_count = format('%04d', total_user_orders)
    current_date = Time.current.strftime('%y%m%d')
    self.serial_number = "#{current_date}-#{id || '0'}-#{user_id}-#{formatted_count}"
  end
end
