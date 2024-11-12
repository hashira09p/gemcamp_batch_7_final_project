class Admin::HomeController < ApplicationController
    before_action :authenticate_admin_user!
    def index
        @clients = User.client.all
    end
end
