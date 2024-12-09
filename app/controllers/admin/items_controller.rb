class Admin::ItemController < AdminApplicationController
  before_action :set_item, only: [:edit, :update, :destroy, :start, :pause, :end, :cancel]

  def index
    @items = Item.includes(:categories).all
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    item_size = Item.all.count
    @item.batch_count = item_size + 1
    if @item.save
      redirect_to item_index_path, notice: 'Item was successfully created.'
    else
      render :show
    end
  end

  def edit; end

  def update
    if @item.update(item_params)
      flash[:notice] = 'Succesfully updated'
      redirect_to item_index_path
    end
  end

  def destroy
    if @item.destroy
      flash[:notice] = 'Succesfully deleted'
      redirect_to item_index_path
    else
      flash[:alert] = @item.errors.messages
      redirect_to item_index_path
    end
  end

  def start
    if @item.may_start?
      @item.start!
      flash[:notice] = 'Success'
      redirect_to item_index_path
    else
      flash[:alert] = @item.errors.full_messages.to_sentence
      redirect_to item_index_path
    end
  end

  def pause
    if @item.may_pause?
      @item.pause!
      flash[:notice] = 'Success'
      redirect_to item_index_path
    else
      flash[:alert] = @item.errors.full_messages.to_sentence
      redirect_to item_index_path
    end
  end

  def end
    if @item.may_end?
      @item.end!
      flash[:notice] = 'Success'
      redirect_to item_index_path
    else
      flash[:alert] = @item.end!.errors.full_messages.to_sentence
      redirect_to item_index_path
    end
  end

  def cancel
    if @item.may_cancel?
      @item.cancel!
      flash[:notice] = 'Success'
      redirect_to item_index_path
    else
      flash[:alert] = @item.errors.full_messages.to_sentence
      redirect_to item_index_path
    end
  end

  private

  def set_item
    @item = Item.find(params[:id] || params[:item_id])
  end

  def item_params
    params.require(:item).permit(
      :image,
      :name,
      :quantity,
      :minimum_tickets,
      :online_at,
      :offline_at,
      :start_at,
      :status,
      category_ids: []
    )
  end
end