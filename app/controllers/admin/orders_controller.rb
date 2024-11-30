class Admin::OrdersController < ApplicationController
  before_action :set_order, only: [:pay, :cancel]
  def index
    @offers = Offer.pluck(:name, :id)
    @orders = Order.includes(:user, :offer).page(params[:page]).per(5)
    @amount_subtotal = @orders.map(&:amount).sum
    @amount_total = Order.all

    @coins_subtotal = @orders.map(&:coin).sum
    @coins_total = Order.all

    @orders = @orders.where(serial_number: params[:serial_number])
                     .page(params[:page]).per(5) if params[:serial_number].present?

    @orders = @orders.where(user: { email: params[:email] })
                     .page(params[:page]).per(5) if params[:email].present?

    @orders = @orders.where(genre: params[:genre])
                     .page(params[:page]).per(5) if params[:genre].present?

    @orders = @orders.where(state: params[:state])
                     .page(params[:page]).per(5) if params[:state].present?

    @orders = @orders.where(offer: params[:offer])
                     .page(params[:page]).per(5) if params[:offer].present?

    if params[:start_date].present? && params[:end_date].present?
      @orders = @orders.where(created_at: params[:start_date]..params[:end_date])
    end
  end

  def pay
    if @order.may_pay?
      @order.pay!
      flash[:notice] = 'Paid successfully'
      redirect_to orders_path
    else
      flash[:alert] = 'Pay unsuccessful'
      redirect_to orders_path
    end
  end

  def cancel
    if @order.may_cancel?
      @order.cancel!
      flash[:notice] = 'Paid successfully'
      redirect_to orders_path
    else
      flash[:alert] = 'Pay unsuccessful'
      redirect_to orders_path
    end
  end

  private

  def set_order
    @order = Order.find(params[:order_id])
  end
end