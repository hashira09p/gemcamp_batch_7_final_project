class Admin::HomeController < AdminApplicationController
    def index
        @clients = User.client.all.page(params[:page]).per(5)
    end
end
