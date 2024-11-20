class Admin::WinnersController < ApplicationController
  def index
    @winner_states = Winner.pluck(:state).uniq
    @winners = Winner.includes(:user) # Eager load for performance

    if params[:serial_number].present?
      @winners = @winners.where('LOWER(serial_number) LIKE ?', "%#{params[:serial_number].downcase}%")
    end

    if params[:email].present?
      @winners = @winners.joins(:user).where('LOWER(users.email) LIKE ?', "%#{params[:email].downcase}%")
    end

    if params[:state].present?
      @winners = @winners.where(state: params[:state])
    end

    if params[:start_date].present? && params[:end_date].present?
      @winners = @tickets.where(created_at: params[:start_date]..params[:end_date])
    end
  end

  def create;end

  def submit
    if @winner.may_submit?
      @winner.submit!
      flash[:notice] = 'Success'
      redirect_to winners_path
    else
      flash[:alert] = @winner.errors.full_messages.to_sentence
      redirect_to winners_path
    end
  end

  def pay
    if @winner.may_pay?
      @winner.pay!
      flash[:notice] = 'Success'
      redirect_to winners_path
    else
      flash[:alert] = @winner.errors.full_messages.to_sentence
      redirect_to winners_path
    end
  end

  def ship
    if @winner.may_ship?
      @winner.ship!
      flash[:notice] = 'Success'
      redirect_to winners_path
    else
      flash[:alert] = @winner.errors.full_messages.to_sentence
      redirect_to winners_path
    end
  end

  def deliver
    if @winner.may_deliver?
      @winner.deliver!
      flash[:notice] = 'Success'
      redirect_to winners_path
    else
      flash[:alert] = @winner.errors.full_messages.to_sentence
      redirect_to winners_path
    end
  end

  def publish
    if @winner.may_publish?
      @winner.publish!
      flash[:notice] = 'Success'
      redirect_to winners_path
    else
      flash[:alert] = @winner.errors.full_messages.to_sentence
      redirect_to winners_path
    end
  end

  def remove_publish
    if @winner.may_remove_publish?
      @winner.remove_publish!
      flash[:notice] = 'Success'
      redirect_to winners_path
    else
      flash[:alert] = @winner.errors.full_messages.to_sentence
      redirect_to winners_path
    end
  end
end