class Admin::ItemsController < AdminApplicationController
  before_action :set_item, only: [:edit, :update, :destroy, :start, :pause, :end, :cancel]

  def index
    @items = Item.includes(:categories).page(params[:page]).per(10)

    respond_to do |format|
      format.html
      format.csv do
        csv_string = CSV.generate do |csv|
          csv << [
            Item.human_attribute_name(:image),
            Item.human_attribute_name(:name),
            Item.human_attribute_name(:quantity),
            Item.human_attribute_name(:minimum_tickets),
            Item.human_attribute_name(:categories),
            Item.human_attribute_name(:state),
            Item.human_attribute_name(:batch_count),
            Item.human_attribute_name(:online_at),
            Item.human_attribute_name(:offline_at),
            Item.human_attribute_name(:start_at),
            Item.human_attribute_name(:status)
          ]

          @items.each do |item|
            csv << [
              item.image,
              item.name,
              item.quantity,
              item.minimum_tickets,
              item.categories.join('-'),
              item.state,
              item.batch_count,
              item.online_at,
              item.offline_at,
              item.start_at,
              item.status
            ]
          end
        end

        render plain: csv_string
      end
    end
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    item_size = Item.all.count
    @item.batch_count = item_size + 1
    if @item.save
      redirect_to items_path, notice: 'Item was successfully created.'
    else
      flash[:alert] = @item.errors.full_messages.to_sentence || 'Item was not created.'
      redirect_to new_item_path
    end
  end

  def edit;end

  def update
    if @item.update(item_params)
      flash[:notice] = 'Succesfully updated'
      redirect_to items_path
    end
  end

  def destroy
    if @item.destroy
      flash[:notice] = 'Succesfully deleted'
      redirect_to items_path(params[:page])
    else
      flash[:alert] = @item.errors.messages
      redirect_to items_path(params[:page])
    end
  end

  def start
    if @item.may_start?
      @item.start!
      flash[:notice] = 'Success'
      redirect_to items_path(params[:page])
    else
      flash[:alert] = @item.errors.full_messages.to_sentence
      redirect_to items_path(params[:page])
    end
  end

  def pause
    if @item.may_pause?
      @item.pause!
      flash[:notice] = 'Success'
      redirect_to items_path(params[:page])
    else
      flash[:alert] = @item.errors.full_messages.to_sentence
      redirect_to items_path(params[:page])
    end
  end

  def end
    if @item.may_end?
      @item.end!
      flash[:notice] = 'Success'
      redirect_to items_path(params[:page])
    else
      flash[:alert] = @item.end!.errors.full_messages.to_sentence
      redirect_to items_path(params[:page])
    end
  end

  def cancel
    if @item.may_cancel?
      @item.cancel!
      flash[:notice] = 'Success'
      redirect_to items_path(params[:page])
    else
      flash[:alert] = @item.errors.full_messages.to_sentence
      redirect_to items_path(params[:page])
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