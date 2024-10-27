class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]

  private

  # Allow only 'client' role during sign up
  def check_admin_role
    if params[:user][:role] == 'admin'
      redirect_to admin_home_login_path, alert: 'Admin sign-up is restricted.'
    end
  end
end