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
     @user_client.username = nil if @user_client.blank?
     if super
       flash[:notice] = "Success"
       redirect_to home_index_path
     else
       flash[:alert] = "Email exist"
       redirect_to new_client_user_registration_path
     end
   end


  # GET /resource/edit
  def edit
    render 'devise/registrations/edit'
  end

  # PUT /resource
  def update
    @client_user = current_client_user  # Assuming current_client_user returns the logged-in user

    if @client_user.valid_password?(params[:client_user][:current_password]) && params[:client_user][:username].present? && params[:client_user][:image].present?
      if @client_user.update(username: params[:client_user][:username], image: params[:client_user][:image])
        flash[:notice] = 'Update Success'
        redirect_to client_root_path
      else
        flash[:alert] = @client_user.errors.full_messages.to_sentence
        redirect_to edit_client_user_registration_path
      end

    elsif  @client_user.valid_password?(params[:client_user][:current_password]) && params[:client_user][:username].present?
            if @client_user.update(username: params[:client_user][:username], image: params[:client_user][:image])
              flash[:notice] = 'Update Success'
              redirect_to client_root_path
            else
              flash[:alert] = @client_user.errors.full_messages.to_sentence
              redirect_to edit_client_user_registration_path
            end

    elsif  @client_user.valid_password?(params[:client_user][:current_password]) && params[:client_user][:image].present?
      if @client_user.update(image: params[:client_user][:image])
        flash[:notice] = 'Update Success'
        redirect_to client_root_path
      else
        flash[:alert] = @client_user.errors.full_messages.to_sentence
        redirect_to edit_client_user_registration_path
      end

    elsif params[:client_user][:password] == params[:client_user][:password_confirmation] && @client_user.valid_password?(params[:client_user][:current_password])

      if params[:client_user][:username].present?
        @client_user.update(username: params[:client_user][:username], password: params[:client_user][:password])
        redirect_to new_client_user_session_path
      else
        @client_user.update(password: params[:client_user][:password])
        redirect_to new_client_user_session_path
      end
    else
      flash[:alert] = 'Invalid password or username is blank'
      redirect_to edit_client_user_registration_path
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
    params.require(:client_user).permit(:email, :password)
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
