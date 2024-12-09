class Admin::BannersController < AdminApplicationController
  before_action :set_params, only: [:create,:update]
  before_action :set_banner, only: [:edit, :destroy, :update]
  def index
    @banners = Banner.all
  end

  def new
    @banner = Banner.new
  end

  def edit;end

  def create
    @banner = Banner.new(set_params)
    if @banner.save
      redirect_to banners_path, notice: 'Banner was successfully created.'
    else
      redirect_to new_banner_path, alert: @banner.errors.full_messages.to_sentence
    end
  end

  def update
    if @banner.update(set_params)
      redirect_to banners_path, notice: 'Banner was successfully updated.'
    else
      redirect_to edit_banner_path, alert: @banner.errors.full_messages.to_sentence
    end
  end

  def destroy
    if @banner.destroy
      flash[:notice] = 'Succesfully deleted'
    else
      flash[:alert] = @banner.errors.messages
    end
    redirect_to banners_path
  end

  private

  def set_banner
    @banner = Banner.find(params[:id])
  end

  def set_params
    params.require(:banner).permit(:preview, :status, :online_at, :offline_at)
  end
end