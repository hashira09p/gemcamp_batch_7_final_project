class Winner < ApplicationRecord
  include AASM

  aasm column: :state do
    state :won, initial: true
    state :claimed
    state :submitted
    state :paid
    state :shipped
    state :delivered
    state :shared
    state :published
    state :remove_published

    event :won do
      transitions from: :won, to: :claimed
    end

    event :claimed do
      transitions from: :claimed, to: :submitted
    end

    event :submitted do
      transitions from: :submitted, to: :paid
    end

    event :paid do
      transitions from: :paid, to: :shipped
    end

    event :shipped do
      transitions from: :shipped, to: :delivered
    end

    event :delivered do
      transitions from: :delivered, to: :shared
    end

    event :shared do
      transitions from: :shared, to: :published
    end

    event :published do
      transitions from: :published, to: :remove_published
    end

    event :remove_published do
      transitions from: :remove_published, to: :published
    end
  end
end
