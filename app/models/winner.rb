class Winner < ApplicationRecord
  include AASM
  mount_uploader :image, ImageUploader
  belongs_to :item
  belongs_to :ticket
  belongs_to :address
  belongs_to :user

  before_create :set_default_address_id


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

    event :claim do
      transitions from: :won, to: :claimed
    end

    event :submit do
      transitions from: :claimed, to: :submitted
    end

    event :pay do
      transitions from: :submitted, to: :paid
    end

    event :ship do
      transitions from: :paid, to: :shipped
    end

    event :deliver do
      transitions from: :shipped, to: :delivered
    end

    event :share do
      transitions from: :delivered, to: :shared
    end

    event :publish do
      transitions from: [:shared, :remove_published], to: :published
    end

    event :remove_publish do
      transitions from: :published, to: :remove_published
    end

  end

  private

  def set_default_address_id
    self.address_id = nil # Set it to nil or any default value
  end
end
