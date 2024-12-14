class Admin::BannersController < AdminApplicationController
  before_action :set_params, only: [:create]
  before_action :set_params_for_update, only: [:update]
  before_action :set_banner, only: [:edit, :destroy, :update]
  def index
    @banners = Banner.where.not(sort: nil).order(sort: :asc).page(params[:page]).per(6)
  end

  def new
    @banner = Banner.new
  end

  def edit;end

  def create
    @banner = Banner.new(set_params)
    @last_banner_sort = Banner.maximum(:sort) || 0
    @banner.sort = @last_banner_sort + 1
    if @banner.save
      redirect_to banners_path, notice: 'Banner was successfully created.'
    else
      redirect_to new_banner_path, alert: @banner.errors.full_messages.to_sentence
    end
  end

  def update
    if @banner.update(set_params_for_update)
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

  def set_params_for_update
    params.require(:banner).permit(:preview, :status, :sort, :online_at, :offline_at)
  end
end