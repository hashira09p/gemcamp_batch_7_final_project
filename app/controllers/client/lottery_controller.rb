class Client::LotteryController < ApplicationController
  before_action :set_item, only: :show
  before_action :set_user, only: :show
  before_action :authenticate_client_user!, except: :index

  def index
    @news_tickers = NewsTicker.where(status: 'active').order(created_at: :desc).first(5)
    @banners = Banner.where(status: 'active')
    filter
  end

  def show
    @item
    @item_serial_numbers = @user.tickets.where(item_id: params[:id], state: 'pending' )
  end

  def create
    number_of_tickets = params[:minimum_tickets].to_i
    item = Item.find params[:item_id].to_i

    if item.quantity >= 0
      number_of_tickets.times do
        ticket = Ticket.new(item: item, user: current_client_user, batch_count: item.batch_count)
        if ticket.save
          flash[:notice] = 'Ticket Created'
        else
          flash[:alert] = ticket.errors.full_messages.join(', ')
        end
      end
      redirect_to lottery_path(item)
    else
      redirect_to lottery_path(item)
      flash[:notice] = 'Invalid input'
    end
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def set_user
    @user = current_client_user
  end

  def filter
    if params[:category] == 'All' || params[:category].blank?
      @items = Item.where(status: 'active', state: 'starting')
                   .page(params[:page]).per(8)
    else
      @items = Item.includes(:categories).where(status: 'active', state: 'starting')
                   .where(categories: { name: params[:category] })
                   .page(params[:page]).per(8)
    end
  end
end