class Order < ApplicationRecord
  include AASM
  enum status: { deposit: 0, increase: 1, deduct: 2, bonus: 3, share: 4 }

  belongs_to :user
  belongs_to :offer, if: :deposit?

  before_create :generate_serial_number

  validates :amount, presence: true, numericality: { greater_than: 0 }, if: :deposit?
  validates :coins, presence: true, numericality: { greater_than: 0 }, if: :deposit?

  aasm column: :state do
    state :pending, initial: true
    state :submitted
    state :cancelled
    state :paid

    event :submit do
      transitions from: :pending, to: :submitted
    end

    event :cancel do
      transitions from: [:pending, :submitted, :paid], to: :cancelled
    end

    event :pay do
      transitions from: :submitted, to: :paid, guard: :check_user_coins,
                  after: [:paid_increase_coins, :paid_decrease_coins, :paid_increase_total_deposit]
    end
  end

  private

  def paid_increase_coins
    user.coins += 1 if !deduct?
  end

  def paid_decrease_coins
    user.coins -= 1 if deduct?
  end

  def paid_increase_total_deposit
    user.total_deposit += 1 if deposit?
  end

  def cancelled_increase_coins
    user.coins -= 1 if !deduct?
  end

  def check_user_coins
    user.coins > 0
  end

  def cancelled_decrease_coins
    user.coins += 1 if deduct?
  end

  def cancelled_increase_total_deposit
    user.total_deposit -= 1 if deposit?
  end

  def generate_serial_number
    total_user_orders = user.orders.count + 1
    formatted_count = format('%04d', total_user_orders)
    current_date = Time.current.strftime('%y%m%d')
    self.serial_number = "#{current_date}-#{id || '0'}-#{user_id}-#{formatted_count}"
  end
end
