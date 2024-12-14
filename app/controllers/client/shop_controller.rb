class Client::ShopController < ApplicationController
  before_action :authenticate_client_user!, except: [:index, :show]
  before_action :set_offer, only: :create

  def index
    @offers = Offer.all.active
    @order = Order.new
  end

  def show;end

  def create
    case @offer.genre

    when 'one_time'
      if Order.where(user: current_client_user, offer: @offer, state: [:pending, :submitted, :paid]).exists?
        flash[:alert] = 'You can only purchase once in this offer!'
      else
        @order = Order.new(user: current_client_user, offer: @offer, amount: @offer.amount, coin: @offer.coin)
        @order.save
        @order.submit!
        flash[:notice] = 'Order Success! Please wait any seconds before you receive your coins.'
      end
      redirect_to shop_index_path

    when 'monthly'
      if Order.where(user: current_client_user, offer: @offer, state: [:pending, :submitted, :paid])
              .where('created_at >= ?', Time.current.beginning_of_month).exists?

        flash[:alert] = 'You can only purchase once per month in this offer!'
      else
        @order = Order.new(user: current_client_user, offer: @offer, amount: @offer.amount, coin: @offer.coin)
        @order.save
        @order.submit!
        flash[:notice] = 'Order Success! Please wait any seconds before you receive your coins.'
      end
      redirect_to shop_index_path

    when 'weekly'
      if Order.where(user: current_client_user, offer: @offer, state: [:pending, :submitted, :paid])
              .where('created_at >= ?', Time.current.beginning_of_week).exists?

        flash[:alert] = 'You can only purchase once per week in this offer!'
      else
        @order = Order.new(user: current_client_user, offer: @offer, amount: @offer.amount, coin: @offer.coin)
        @order.save
        @order.submit!
        flash[:notice] = 'Order Success! Please wait any seconds before you receive your coins.'
      end
      redirect_to shop_index_path

    when 'daily'
      if Order.where(user: current_client_user, offer: @offer, state: [:pending, :submitted, :paid])
              .where('created_at >= ?', Time.current.beginning_of_day).exists?

        flash[:alert] = 'You can only purchase once per day in this offer!'
      else
        @order = Order.new(user: current_client_user, offer: @offer, amount: @offer.amount, coin: @offer.coin)
        @order.save
        @order.submit!
        flash[:notice] = 'Order Success! Please wait any seconds before you receive your coins.'
      end
      redirect_to shop_index_path

    when 'regular'
      @order = Order.new(user: current_client_user, offer: @offer, amount: @offer.amount, coin: @offer.coin)
      @order.save
      @order.submit!
      flash[:notice] = 'Order Success! Please wait any seconds before you receive your coins.'
      redirect_to shop_index_path
    else
      flash[:alert] = "Failed to purchse offer"
      redirect_to shop_index_path
    end
  end

  private

  def set_offer
    @offer = Offer.find(params[:offer_id])
  end
end