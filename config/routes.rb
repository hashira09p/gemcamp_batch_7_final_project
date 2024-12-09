Rails.application.routes.draw do

  constraints(AdminDomainConstraint.new) do
    scope module: 'admin' do
      devise_for :users, controllers: {
        sessions: 'admin/sessions'
      }, as: :admin

      resources :home
      resources :items do
        patch :start
        patch :pause
        patch :end
        patch :cancel
      end

      namespace :users do
        resources :clients do
          resources :orders do
            collection do
              get 'increase/new', to: 'orders#new_increase', as: 'new_increase'
              post 'increase', to: 'orders#create_increase'
              get 'deduct/new', to: 'orders#new_deduct', as: 'new_deduct'
              post 'deduct', to: 'orders#create_deduct'
              get 'bonus/new', to: 'orders#new_bonus', as: 'new_bonus'
              post 'bonus', to: 'orders#create_bonus'
            end
          end
        end
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
      resources :banners
      resources :category
      resources :invite_lists
      resources :news_tickers
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
      resources :winners
    end
    root 'client/home#index', as: :client_root
    get 'client/profile', to: 'client/home#profile'
    get 'client/lottery_history', to: 'client/home#lottery_history'
    get 'client/winning_history', to: 'client/home#winning_history'
    get 'client/invitation_history', to: 'client/home#invitation_history'
    get 'winners/:id/share', to: 'client/winners#share'
    patch 'winners/:id/share', to: 'client/winners#update_winner_to_shared'
    patch 'profile/:order_id/cancel', to: 'client/orders#cancel', as: :cancel_order
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
