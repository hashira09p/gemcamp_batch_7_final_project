class Admin::OrdersController < ApplicationController
  before_action :set_order, only: [:pay, :cancel]
  def index
    @orders = Order.includes(:user).page(params[:page]).per(5)
    @amount_subtotal = @orders.map(&:amount).sum
    @amount_total = Order.all

    @coins_subtotal = @orders.map(&:coin).sum
    @coins_total = Order.all
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