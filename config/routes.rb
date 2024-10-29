Rails.application.routes.draw do
  devise_for :users, path: '', path_names: {
    sign_in: 'sign_in',
    sign_out: 'sign_out',
    sign_up: 'sign_up'
  }

  constraints AdminDomainConstraint.new do
    authenticated :user, ->(u) { u.admin? } do
      root to: 'admin/home#index', as: :admin_root
    end

  end

  constraints ClientDomainConstraint.new do
    authenticated :user, ->(u) { u.client? } do
      root to: 'client/home#index', as: :client_root
    end
    get 'client/home', to: 'client/home#profile'
  end

  root to: 'client/home#index'
end
