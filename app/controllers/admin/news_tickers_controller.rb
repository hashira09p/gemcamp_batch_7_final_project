class Admin::NewsTickersController < AdminApplicationController
  before_action :set_params, only: [:create]
  before_action :set_news_ticker, only: [:edit, :destroy, :update]
  before_action :set_params, only: [:create, :update]
  def index
    @news_tickers = NewsTicker.where.not(sort: nil).order(sort: :asc).page(params[:page]).per(6)
  end

  def new
    @news_ticker = NewsTicker.new
  end

  def create
    @news_ticker = NewsTicker.new(set_params)
    # @last_news_ticker_sort = NewsTicker.maximum(:sort) || 0
    # @news_ticker.sort = @last_news_ticker_sort + 1
    @news_ticker.admin = current_admin_user
    if @news_ticker.save
      flash[:notice] = 'News Ticker was successfully created.'
      redirect_to news_tickers_path
    else
      flash[:alert] = 'Failed to Create News Ticker'
      redirect_to new_news_ticker_path
    end
  end

  def edit;end

  def update
    if @news_ticker.update(set_params)
      redirect_to news_tickers_path, notice: 'News Ticker was successfully created.'
    else
      render :new, alert: 'Failed to Create News Ticker'
    end
  end

  def destroy
    if @news_ticker.destroy
      flash[:notice] = 'Succesfully deleted'
    else
      flash[:alert] = @news_ticker.errors.full_messages.to_sentence
    end
    redirect_to news_tickers_path
  end

  private

  def set_news_ticker
    @news_ticker = NewsTicker.find(params[:id])
  end

  def set_params
    params.require(:news_ticker).permit(:content, :status, :sort)
  end
end