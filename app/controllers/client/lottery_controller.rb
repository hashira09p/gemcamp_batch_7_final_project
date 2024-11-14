class Client::LotteryController < ApplicationController
  def index
      filter
  end

  private

  def filter
    if params[:category] == 'All' || params[:category].blank?
      @items = Item.all
                      # Exclude deleted items
    else
      @items = Item.includes(:categories).where(categories: {name: params[:category]})
    end
  end
end