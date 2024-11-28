Rails.application.routes.draw do

  constraints(AdminDomainConstraint.new) do
    scope module: 'admin' do
      devise_for :users, controllers: {
        sessions: 'admin/sessions'
      }, as: :admin

      resources :home
      resources :item do
        patch :start
        patch :pause
        patch :end
        patch :cancel
      end

      resources :winners do
        patch :won
        patch :claim
        patch :submit
        patch :pay
        patch :ship
        patch :deliver
        patch :share
        patch :publish
        patch :remove_publish
      end
      resources :category
      resources :tickets
      resources :offers
      resources :orders do
        patch :submit
        patch :pay
        patch :cancel
      end
    end
    root 'admin/home#index', as: :admin_root
    get 'admin/home', to: 'admin/home#index'
  end

  constraints(ClientDomainConstraint.new) do
    scope module: 'client' do
      devise_for :users, controllers: {
        sessions: 'users/sessions',
        registrations: 'client/registrations'
      }, as: :client

      resources :addresses
      resources :home
      resources :lottery
      resources :shop
    end
    root 'client/home#index', as: :client_root
    get 'client/profile', to: 'client/home#profile'
    get 'client/lottery_history', to: 'client/home#lottery_history'
    get 'users/edit', to: 'client/registrations#edit', as: :edit_client_user_registration_path

    namespace :api do
      namespace :v1 do
        resources :regions, only: %i[index show], defaults: { format: :json } do
          resources :provinces, only: :index, defaults: { format: :json }
        end

        resources :provinces, only: %i[index show], defaults: { format: :json } do
          resources :cities, only: :index, defaults: { format: :json }
        end

        resources :cities, only: %i[index show], defaults: { format: :json } do
          resources :barangays, only: :index, defaults: { format: :json }
        end

        resources :barangays, only: %i[index show], defaults: { format: :json }
      end
    end
  end
end
