class Admin::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]
  before_action :set_admin

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create;end

  # GET /resource/edit
   def edit
     render 'devise/registrations/admin/edit'
   end

  def update
    if params[:admin_user][:password] == params[:admin_user][:password_confirmation]

      @admin_user.update(email: params[:admin_user][:email], username: params[:admin_user][:username], coins: params[:admin_user][:coins], password: params[:admin_user][:password], image: params[:admin_user][:image])

      flash[:alert] = 'Update Successfully'
      redirect_to admin_root_path
    elsif params[:admin_user][:current_password].present?

      @admin_user.update(email: params[:admin_user][:email], username: params[:admin_user][:username], coins: params[:admin_user][:coins])

      flash[:alert] = 'Update Successfully'
      redirect_to admin_root_path
    else
      flash[:alert] = 'Update failed'
      redirect_to edit_admin_user_registration_path_path
    end
  end

  private

  def set_admin
    @admin_user = User.admin.find_by(email: current_admin_user.email)
  end
  def set_params
    params.require(:admin_user).permit(:email, :image, :username, :coins, :password, :password_confirmation, :current_password)
  end
  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end


  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end