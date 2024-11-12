class Admin::ItemController < ApplicationController
  before_action :set_item, only: [:edit, :update, :destroy]
  def index
    @items = Item.all
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to item_index_path, notice: 'Item was successfully created.'
    else
      render :new
    end
  end

  def edit;end

  def update
    if @item.update!(item_params)
      flash[:notice] = 'Succesfully updated'
      redirect_to item_index_path
    end
  end

  def destroy
    if @item.destroy
      flash[:notice] = 'Succesfully deleted'
      redirect_to item_index_path
    end
  end

  private

  def set_item
    @item = Item.find_by(params[:id])
  end

  def item_params
  params.require(:item).permit(
      :name,
      :quantity,
      :minimum_tickets,
      :batch_count,
      :online_at,
      :offline_at,
      :start_at,
      :status
  )
  end
end