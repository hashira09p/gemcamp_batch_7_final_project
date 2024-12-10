class Client::SharesController < ApplicationController
  def index
    @banners = Banner.where(status: 'active')
    @news_tickers = NewsTicker.where(status: 'active').order(created_at: :desc).first(5)
    @winners = Winner.includes(:item, :user).where(state: 'published')
                     .order(updated_at: :desc)
                     .page(params[:page])
                     .per(6)
  end
end