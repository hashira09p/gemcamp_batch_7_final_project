class Client::WinnersController < ApplicationController
  before_action :set_winner, only: [:show, :update]
  before_action :set_params, only: [:update]
  def show
   @addresses = current_client_user.addresses
  end

  def update
    puts set_params
    winner = Winner.find(@winner_ticket.id)
    if winner.update(address_id: set_params)
      flash[:notice] = "Successfully claimed the prize."
      winner.claim!
      winner.save
      redirect_to client_profile_path
    else
      flash[:alert] = "Failed!"
      redirect_to client_profile_path
    end
  end

  private

  def set_winner
    @winner_ticket = current_client_user.winners.find(params[:id])
  end

  def set_params
    puts :address_id
    params.require(:address_id)
  end
end