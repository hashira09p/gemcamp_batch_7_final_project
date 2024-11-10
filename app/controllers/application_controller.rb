class ApplicationController < ActionController::Base
  before_action :authenticate_client_user!
end