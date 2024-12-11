class Admin::Users::OrdersController < AdminApplicationController
  before_action :set_client_user, only: [:new_increase, :create_increase, :create_deduct, :new_deduct, :new_bonus]
  before_action :set_params, only: [:create_increase, :create_deduct]
  def new_increase
    @order = Order.new
  end

  def create_increase
    @order = Order.new(set_params)
    @order.user_id = @client_user.id
    @order.amount = params[:order][:coin].to_i * 20
    if @order.save
      flash[:notice] = 'increase order has successfully created'
    else
      flash[:alert] = 'Failed to create order'
    end
    redirect_to new_increase_users_client_orders_path
  end

  def new_deduct
    @order = Order.new
  end

  def create_deduct
    @order = Order.new(set_params)
    @order.user_id = @client_user.id
    @order.amount = rand(1...9999)
    if @order.save
      flash[:notice] = 'Deduct order has successfully created'
    else
      flash[:alert] = 'Failed to create order'
    end
    redirect_to new_increase_users_client_orders_path
  end

  def new_bonus
    @order = Order.new
  end

  private

  def set_client_user
    @client_user = User.client.find(params[:client_id])
  end

  def set_params
    params.require(:order).permit(:coin, :genre, :remarks)
  end
end