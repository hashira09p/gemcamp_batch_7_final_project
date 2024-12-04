class Client::ShopController < ApplicationController
  before_action :authenticate_client_user!, except: [:index, :show]
  before_action :set_offer, only: :create

  def index
    @offers = Offer.all.active
    @order = Order.new
  end

  def show;end

  def create
    @order = Order.new(user: current_client_user, offer: @offer, amount: @offer.amount, coin: @offer.coin)
    if @order.save
      flash[:notice] = 'Order Success! Please wait 2 minutes before you receive your coins.'
      redirect_to shop_index_path
    else
      flash[:alert] = @order.errors.full_messages.join(', ')
      redirect_to shop_index_path
    end
  end

  private

  def set_offer
    @offer = Offer.find(params[:offer_id])
  end
end