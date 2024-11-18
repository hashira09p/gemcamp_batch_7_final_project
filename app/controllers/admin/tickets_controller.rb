class Admin::TicketsController < ApplicationController
  def index
    @ticket_states = Ticket.pluck(:state).uniq
    @tickets = Ticket.includes(:item, :user).all

    if params[:serial_number].present?
      @tickets = Product.where('serial_number LIKE ?', '%#{Pro}%')
    end

    if params[:item_name].present?
      @tickets = Ticket.find_by(item_id: params[:item_name])
    end

    if params[:email].present?
      @tickets = Ticket.where('users.email LIKE ?', "%#{params[:email]}%")
    end

    if params[:state].present?
      @tickets = Ticket.where(state: params[:state])
    end

    if params[:start_date].present? && params[:end_date].present?
      @tickets = Ticket.where(created_at: params[:start_date]..params[:end_date])
    end
  end

end