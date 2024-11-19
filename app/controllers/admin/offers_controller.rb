class Admin::OffersController < ApplicationController
  before_action :offer_params, only: :create
  def index
    @offers = Offer.all
  end

  def new
    @offer = Offer.new
  end

  def create
    @offer = Offer.new(offer_params)
    if @offer.save
      redirect_to offers_path, notice: 'Offer was successfully created.'
    else
      render :show
      flash[:alert] = "Failed To Add"
    end
  end

  private

  def offer_params
    params.require(:offer).permit(:name, :status, :amount, :coin, :image)
  end
end