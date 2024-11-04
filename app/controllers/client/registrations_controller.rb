class Client::RegistrationsController < Devise::RegistrationsController
  before_action :set_client_username, only: :create
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]
  # GET /resource/sign_up
  #  def new
  #    render 'devise/registrations'
  #  end

  # POST /resource
   def create
     @user_client = User.client.new(user_params)
     if @client_username.present?
       flash[:alert] = 'Username Exist'
       redirect_to new_client_user_registration_path
     elsif @user_client.save
       flash[:alert] = 'Registered successfully'
       redirect_to new_client_user_session_path
     else
       flash[:alert] = 'Failed to Registered'
       redirect_to new_client_user_registration_path
     end
   end


  # GET /resource/edit
  def edit
    render 'devise/registrations/edit'
  end

  # PUT /resource
  def update
    if params[:client_user][:password] == params[:client_user][:password_confirmation]

      @client_user.update(email: params[:client_user][:email], username: params[:client_user][:username], coins: params[:client_user][:coins], password: params[:client_user][:password])

      flash[:alert] = 'Update Successfully'
      redirect_to client_root_path
    elsif params[:client_user][:current_password].present?

      @client_user.update(email: params[:client_user][:email], username: params[:client_user][:username], coins: params[:client_user][:coins])

      flash[:alert] = 'Update Successfully'
      redirect_to client_root_path
    else
      flash[:alert] = 'Update failed'
      redirect_to edit_client_user_registration_path_path
    end
  end

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

  private

  def set_client_username
    @client_username = User.client.find_by(username: params[:client_user][:username])
  end
  def user_params
    params.require(:client_user).permit(:username, :email, :password)
  end


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
