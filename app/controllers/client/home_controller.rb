class Client::HomeController < ApplicationController
  before_action :authenticate_client_user!, except: [:index]
  def index
    @winners = Winner.includes(:item, :user).order(updated_at: :desc)
  end

  def new
    @user = User.new
    @qrcode = RQRCode::QRCode.new(invitation_link)

    @qrcode_png = @qrcode.as_svg(
      light: "\033[47m", dark: "\033[40m",
      fill_character: "  ",
      quiet_zone_size: 4
    )
  end

  def profile
    @client_orders = current_client_user.orders
  end

  def lottery_history
    @client_tickets = current_client_user.tickets
  end

  def winning_history
    @winning_tickets = current_client_user.winners
  end

  def invitation_history
    @children = current_client_user.children
  end
  
  private

  def invitation_link
    "client.com:3000/users/sign_up?promoter=#{current_client_user}"
  end

  private

  def set_winning_ticket
    @winning_ticket = current_client_user.tickets.find(params[:ticket_id])
  end
end
