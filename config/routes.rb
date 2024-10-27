Rails.application.routes.draw do
  # Define Devise routes for both admin and client
  devise_for :users, path: '', path_names: {
    sign_in: 'sign_in',
    sign_out: 'sign_out',
    sign_up: 'sign_up'
  }

  # Admin routes - only accessible from admin domains
  constraints AdminDomainConstraint.new do
    authenticated :user, ->(u) { u.admin? } do
      root to: 'admin/home#index', as: :admin_root
    end
  end

  # Client routes - only accessible from client domains
  constraints ClientDomainConstraint.new do
    authenticated :user, ->(u) { u.client? } do
      root to: 'client/home#index', as: :client_root
    end
  end

  # Default root redirect to sign-in page for any other requests
  root to: redirect('/sign_in')
end
