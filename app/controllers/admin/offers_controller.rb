class Admin::OffersController < AdminApplicationController
  before_action :set_offer, only: [:edit, :update, :destroy]
  def index
    @offer_status = Offer.pluck(:status).uniq
    @offers = Offer.all

    if params[:status].present?
      @offers = @offers.where(status: params[:status])
    end
  end

  def new
    @offer = Offer.new
  end

  def create
    @offer = Offer.new(offer_params)
    if @offer.save
      redirect_to offers_path, notice: 'Offer was successfully created.'
    else
      render :new
      flash[:alert] = "Failed To Add"
    end
  end

  def edit;end

  def update
    if @offer.update(offer_params)
      redirect_to offers_path, notice: 'Offer was successfully updated.'
    else
      render :edit
      flash[:alert] = "Failed To update"
    end
  end

  def destroy
    if @offer.destroy
      redirect_to offers_path, notice: 'Offer was successfully deleted.'
    else
      render :edit
      flash[:alert] = "Failed To delete"
    end
  end

  private

  def set_offer
    @offer = Offer.find(params[:id])
  end

  def offer_params
    params.require(:offer).permit(:name, :status, :amount, :coin, :image)
  end
end