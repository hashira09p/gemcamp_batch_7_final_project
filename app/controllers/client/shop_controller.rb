class Client::ShopController < ApplicationController
  before_action :authenticate_user!, except: :index
  def index
  @offers = Offer.all.active
  end
end