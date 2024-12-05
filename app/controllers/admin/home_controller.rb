class Admin::HomeController < AdminApplicationController
    def index
        @clients = User.client.all
    end
end
