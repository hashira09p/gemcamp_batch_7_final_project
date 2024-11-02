Rails.application.routes.draw do

  constraints(AdminDomainConstraint.new) do
    scope module: 'admin' do
      devise_for :users, controllers: {
        sessions: 'admin/sessions',
        registrations: 'admin/registrations'
      }, as: :admin
    end
    root 'admin/home#index', as: :admin_root
    get 'admin/home', to: 'admin/home#index'
    get 'users/edit', to: 'admin/registrations#edit', as: :edit_admin_user_registration_path
  end

  constraints(ClientDomainConstraint.new) do
    devise_for :users, controllers: {
      sessions: 'client/sessions',
      registrations: 'client/registrations'
    }
    root 'client/home#index', as: :client_root
    get 'client/profile', to: 'client/home#profile'
  end
end
