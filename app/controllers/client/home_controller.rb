class Client::HomeController < ApplicationController
  before_action :authenticate_client_user!, except: [:index]

=begin
  def new
    render 'devise/sessions/new'
  end
=end

  def new
    @user = User.new
    @qrcode = RQRCode::QRCode.new(invitation_link)

    @qrcode_png = @qrcode.as_svg(
      light: "\033[47m", dark: "\033[40m",
      fill_character: "  ",
      quiet_zone_size: 4
    )
  end

  def profile; end


  private

  def invitation_link
    "client.com:3000/users/sign_up?promoter=#{current_client_user}"
  end
end
