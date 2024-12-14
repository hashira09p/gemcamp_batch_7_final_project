class Admin::OrdersController < AdminApplicationController
  before_action :set_order, only: [:pay, :cancel, :submit]
  def index
    @offers = Offer.pluck(:name, :id)
    @orders = Order.includes(:user, :offer).page(params[:page]).per(10).order(created_at: :desc)
    @amount_subtotal = @orders.map(&:amount).sum
    @amount_total = Order.all
    @all_orders = Order.all

    @coins_subtotal = @orders.map(&:coin).sum
    @coins_total = Order.all

    @orders = @orders.where(serial_number: params[:serial_number])
                     .page(params[:page]).per(10) if params[:serial_number].present?

    @orders = @orders.where(user: { email: params[:email] })
                     .page(params[:page]).per(10) if params[:email].present?

    @orders = @orders.where(genre: params[:genre])
                     .page(params[:page]).per(10) if params[:genre].present?

    @orders = @orders.where(state: params[:state])
                     .page(params[:page]).per(10) if params[:state].present?

    @orders = @orders.where(offer: params[:offer])
                     .page(params[:page]).per(10) if params[:offer].present?

    if params[:start_date].present? && params[:end_date].present?
      @orders = @orders.where(created_at: params[:start_date]..params[:end_date])
    end

    respond_to do |format|
      format.html
      format.csv do
        csv_string = CSV.generate do |csv|
          csv << [
            Order.human_attribute_name(:ID),
            Order.human_attribute_name(:user_email),
            Order.human_attribute_name(:offer_name),
            Order.human_attribute_name(:serial_number),
            Order.human_attribute_name(:state),
            Order.human_attribute_name(:coin),
            Order.human_attribute_name(:amount),
            Order.human_attribute_name(:remarks),
            Order.human_attribute_name(:genre)
          ]

          @all_orders.each do |order|
            csv << [
              order.id,
              order.user.email,
              order.offer&.name,
              order.serial_number,
              order.state,
              order.coin,
              order.amount,
              order&.remarks,
              order.genre
            ]
          end
        end

        render plain: csv_string
      end
    end
  end

  def pay
    if @order.deduct? && @order.user.coins < @order.coin
      flash[:notice] = 'Cant deduct coins because the user coins cant be negative. You need to cancel the Order'
    else
      if @order.may_pay?
        @order.pay!
        flash[:notice] = 'Paid successfully'
      else
        flash[:alert] = 'Pay unsuccessful'
      end
    end
    redirect_to orders_path(params[:page])
  end

  def submit
    if @order.may_submit?
      @order.submit!
      flash[:notice] = 'Submitted Successfully'
    else
      flash[:alert] = 'Submit Failed'
    end
    redirect_to orders_path(params[:page])
  end

  def cancel
    if @order.may_cancel?
      @order.cancel!
      flash[:notice] = 'Cancelled Successfully'
    else
      flash[:alert] = 'Cancel Failed'
    end
    redirect_to orders_path(params[:page])
  end

  private

  def set_order
    @order = Order.find(params[:order_id])
  end
end