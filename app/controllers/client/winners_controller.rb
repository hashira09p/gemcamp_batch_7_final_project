class Client::WinnersController < ApplicationController
  before_action :set_winner, only: [:show, :update, :share, :update_winner_to_shared]
  before_action :set_params, only: [:update]
  before_action :feedback_params, only: [:update_winner_to_shared]
  def show
   @addresses = current_client_user.addresses
  end

  def share;end

  def update_winner_to_shared
    winner = Winner.find(@winner_ticket.id)
    if winner.update(feedback_params)
      flash[:notice] = "Successfully shared your feedback!."
      winner.share!
      winner.save
      redirect_to client_winning_history_path
    else
      flash[:alert] = "Failed!"
      redirect_to client_winning_history_path
    end
  end

  def update
    winner = Winner.find(@winner_ticket.id)
    if winner.update(address_id: set_params)
      flash[:notice] = "Successfully claimed the prize."
      winner.claim!
      winner.save
      redirect_to client_winning_history_path
    else
      flash[:alert] = "Failed!"
      redirect_to client_winning_history_path
    end
  end

  private

  def set_winner
    @winner_ticket = current_client_user.winners.find(params[:id])
  end

  def set_params
    params.require(:address_id)
  end

  def feedback_params
    params.require(:winner).permit(:comment, :image)
  end
end