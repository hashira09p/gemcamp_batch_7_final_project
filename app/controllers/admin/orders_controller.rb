class Admin::OrdersController < ApplicationController
  def index
    @orders = Order.includes(:user).page(params[:page]).per(5)
    @amount_subtotal = @orders.map(&:amount).sum
    @amount_total = Order.all

    @coins_subtotal = @orders.map(&:coin).sum
    @coins_total = Order.all
  end
end