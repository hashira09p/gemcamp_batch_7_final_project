Rails.application.routes.draw do
  devise_for :users, path: '', controllers: { registrations: 'users/registrations' }, path_names: {
    sign_in: 'sign_in',
    sign_out: 'sign_out',
    sign_up: 'sign_up'
  }

  # Home Controllers for different roles
  authenticated :user, ->(u) { u.admin? } do
    root to: "admin/home#index", as: :admin_root
  end

  authenticated :user, ->(u) { u.client? } do
    root to: "client/home#index", as: :client_root
  end

  # Default root
  root to: redirect('/sign_in')
end
