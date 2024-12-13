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
    @total_tickets = @item.tickets.where(state: 'pending').count
    @item
    @item_serial_numbers = @user.tickets.where(item_id: params[:id], state: 'pending' )
  end

  def create
    number_of_tickets = params[:minimum_tickets].to_i
    item = Item.find_by(id: params[:item_id].to_i)

    if item.nil?
      flash[:alert] = 'Item not found'
      return redirect_to shop_index_path
    end

    if item.quantity <= 0
      flash[:notice] = 'Invalid input'
      return redirect_to lottery_path(item)
    end

    tickets_created = 0
    number_of_tickets.times do
      ticket = Ticket.new(item: item, user: current_client_user, batch_count: item.batch_count)
      if ticket.save
        tickets_created += 1
        flash[:notice] = "#{tickets_created} ticket(s) created successfully"
        return redirect_to lottery_index_path
      else
        flash[:alert] = ticket.errors.full_messages.join(', ') + ". Please Top-Up First!"
        return redirect_to shop_index_path
      end
    end

    if tickets_created > 0
      flash[:notice] = "#{tickets_created} ticket(s) created successfully"
    else
      flash[:alert] = "No tickets were created."
    end

    redirect_to lottery_path(item)
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