class Order < ApplicationRecord
  include AASM
  enum genre: { deposit: 0, increase: 1, deduct: 2, bonus: 3, share: 4, member_level: 5 }

  belongs_to :user
  belongs_to :offer, optional: true

  before_create :generate_serial_number

  validates :amount, presence: true, numericality: { greater_than: 0 }, if: :deposit?
  validates :coin, presence: true, numericality: { greater_than: 0 }, if: :deposit?
  validates :remarks, presence: true, if: :increase?

  aasm column: :state do
    state :pending, initial: true
    state :submitted
    state :cancelled
    state :paid

    event :submit do
      transitions from: :pending, to: :submitted
    end

    event :cancel do
      transitions from: :paid, to: :cancelled, guard: :check_user_coins,
                  success: :user_coins_update_for_cancelled

      transitions from: [:pending, :submitted], to: :cancelled
    end

    event :pay do
      transitions from: :pending, to: :paid, after: :user_coins_update_for_paid, if: -> {!deposit?}

      transitions from: :submitted, to: :paid, after: :user_coins_update_for_paid
    end
  end

  private

  def user_coins_update_for_paid
    if !deduct?
      user.coins += offer&.coin || self.coin
    else
      user.coins -= offer&.coin || self.coin
    end
    user.total_deposit += offer.coin if deposit?
    user.save
  end

  def user_coins_update_for_cancelled
    if !deduct?
      user.coins -= offer&.coin || self.coin
    else
      user.coins += offer&.coin || self.coin
    end
    user.total_deposit -= offer.coin if deposit?
    user.save
  end

  def check_user_coins
    user.coins < self.coin || user.coins > self.coin
  end

  def generate_serial_number
    total_user_orders = user.orders.count + 1
    formatted_count = format('%04d', total_user_orders)
    current_date = Time.current.strftime('%y%m%d')
    self.serial_number = "#{current_date}-#{id || '0'}-#{user_id}-#{formatted_count}"
  end
end
