class Client::LotteryController < ApplicationController
  def index
      filter
  end

  private

  def filter
    if params[:category] == 'All' || params[:category].blank?
      @items = Item.where(status: 'active', state: 'starting')
    else
      @items = Item.includes(:categories).where(categories: {name: params[:category]})
    end
  end
end