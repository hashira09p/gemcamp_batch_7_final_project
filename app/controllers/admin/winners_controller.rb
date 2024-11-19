class Admin::WinnersController < ApplicationController
  def index
    @winners = Winner.all
  end

  def create

  end

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