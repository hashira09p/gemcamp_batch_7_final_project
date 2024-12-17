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
    if @item.ended?
      flash[:alert] = "The item was ended."
      redirect_to lottery_index_path
    elsif @item.cancelled?
      flash[:alert] = "The item was cancelled."
      redirect_to lottery_index_path
    end

    @total_tickets = @item.tickets.where(state: 'pending').count
    @item
    @item_serial_numbers = @user.tickets.where(item_id: params[:id], state: 'pending' )
  end

  def create
    number_of_tickets = params[:minimum_tickets].to_i
    item = Item.find params[:item_id].to_i
    tickets_created = 0
    if item.quantity >= 0
      number_of_tickets.times do
        ticket = Ticket.new(item: item, user: current_client_user, batch_count: item.batch_count)
        if ticket.save
          tickets_created += 1
          flash[:notice] = "#{tickets_created} ticket(s) Created"
        else
          flash[:alert] = ticket.errors.full_messages.join(', ')
        end
      end
      redirect_to lottery_path(item)
    end
  end

  def top_up;end

  def create_top_up;end

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