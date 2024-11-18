class Admin::TicketsController < ApplicationController
  def index
    @ticket_states = Ticket.pluck(:state).uniq
    @tickets = Ticket.includes(:item, :user) # Eager load for performance

    if params[:serial_number].present?
      @tickets = @tickets.where('LOWER(serial_number) LIKE ?', "%#{params[:serial_number].downcase}%")
    end

    if params[:item_name].present?
      @tickets = @tickets.joins(:item).where('LOWER(items.name) LIKE ?', "%#{params[:item_name].downcase}%")
    end

    if params[:email].present?
      @tickets = @tickets.joins(:user).where('LOWER(users.email) LIKE ?', "%#{params[:email].downcase}%")
    end

    if params[:state].present?
      @tickets = @tickets.where(state: params[:state])
    end

    if params[:start_date].present? && params[:end_date].present?
      @tickets = @tickets.where(created_at: params[:start_date]..params[:end_date])
    end
  end
end