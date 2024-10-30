Rails.application.routes.draw do


  constraints AdminDomainConstraint.new do
    authenticated :user, ->(u) { u.admin? } do
      root to: 'admin/home#index', as: :admin_root
    end

  end

  constraints(ClientDomainConstraint.new) do
    devise_for :users, controllers: {
      sessions: 'users/sessions'
    }
    root 'client/home#index', as: :client_root
    get 'client/profile', to: 'client/home#profile'
  end
end
