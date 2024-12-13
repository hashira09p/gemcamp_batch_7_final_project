class Admin::Users::OrdersController < AdminApplicationController
  before_action :set_client_user, only: [:new_increase, :create_increase, :create_deduct, :new_deduct, :new_bonus,
                                         :create_bonus, :new_member_level, :create_member_level]
  before_action :set_params, only: [:create_increase, :create_deduct, :create_bonus, :create_member_level]
  def new_increase
    @order = Order.new
  end

  def create_increase
    @order = Order.new(set_params)
    @order.user_id = @client_user.id
    @order.amount = params[:order][:coin].to_i * 20
    if @order.save
      @order.pay!
      flash[:notice] = 'increase order has successfully created'
      redirect_to admin_home_path
    else
      flash[:alert] = 'Failed to create order'
      redirect_to new_increase_users_client_orders_path
    end
  end

  def new_deduct
    @order = Order.new
  end

  def create_deduct
    @order = Order.new(set_params)
    @order.user_id = @client_user.id
    @order.amount = params[:order][:coin].to_i * 20
    if @order.save
      @order.pay!
      flash[:notice] = 'Deduct order has successfully created'
      redirect_to admin_home_path
    else
      flash[:alert] = 'Failed to create order'
      redirect_to new_increase_users_client_orders_path
    end
  end

  def new_bonus
    @order = Order.new
  end

  def create_bonus
    @order = Order.new(set_params)
    @order.user_id = @client_user.id
    @order.amount = params[:order][:coin].to_i * 20
    if @order.save
      @order.pay!
      flash[:notice] = 'Bonus order has successfully created'
      redirect_to admin_home_path
    else
      flash[:alert] = 'Failed to create order'
      redirect_to new_increase_users_client_orders_path
    end
  end

  def new_member_level
    @order = Order.new
  end

  def create_member_level
    @order = Order.new(set_params)
    @order.user_id = @client_user.id
    @order.amount = params[:order][:coin].to_i * 20
    if @order.save
      @order.pay!
      flash[:notice] = 'Bonus order has successfully created'
      redirect_to admin_home_path
    else
      flash[:alert] = 'Failed to create order'
      redirect_to new_increase_users_client_orders_path
    end
  end
  private

  def set_client_user
    @client_user = User.client.find(params[:client_id])
  end

  def set_params
    params.require(:order).permit(:coin, :genre, :remarks)
  end
end