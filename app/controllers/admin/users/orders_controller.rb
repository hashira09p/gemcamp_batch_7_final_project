class Admin::Users::OrdersController < AdminApplicationController
  before_action :set_client_user, only: [:new_increase, :new_deduct, :new_bonus]
  def new_increase
    @order = Order.new
  end

  def create_increase
  end

  def new_deduct;end

  def new_bonus;end

  private

  def set_client_user
    @client_user = User.client.find(params[:client_id])
  end
end