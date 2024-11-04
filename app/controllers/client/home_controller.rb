class Client::HomeController < ApplicationController
  before_action :authenticate_client_user!
=begin
  def new
    render 'devise/sessions/new'
  end
=end
  def index;end


  def profile;end
end
