class Admin::HomeController < ApplicationController
    before_action :authenticate_admin_user!
    def index;end
end
