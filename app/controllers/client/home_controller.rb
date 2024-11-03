class Client::HomeController < ApplicationController
  def new
    render 'devise/sessions/new'
  end
  def index;end


  def profile
    @current_user = current_client_user
  end
end
