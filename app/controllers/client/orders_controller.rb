class Client::OrdersController < ApplicationController
  before_action :set_order, only: [:cancel, :update]

  def cancel
    if @order.may_cancel?
      @order.cancel!
      flash[:notice] = 'Cancelled Successfully'
    else
      flash[:alert] = 'Cancel Failed'
    end
    redirect_to client_profile_path
  end

  private

  def set_order
    @order = current_client_user.orders.find(params[:order_id])
  end
end