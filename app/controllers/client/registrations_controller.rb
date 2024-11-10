class Client::RegistrationsController < Devise::RegistrationsController
  before_action :store_promoter, only: [:new]
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]
  # GET /resource/sign_up
   def new
     super
   end

  # POST /resource
   def create
     super do |user|
       if cookies[:promoter].present?
         promoter = User.find_by(email: cookies[:promoter])
         user.update(parent_id: promoter.id) if promoter
       end
     end
   end

  # def create
  #   @user_client = User.client.new(user_params)
  #   @user_client.username = nil if @user_client.blank?
  #
  #   if @user_client.save && params[:user][:password] == params[:user][:password_confirmation]
  #     flash[:alert] = "Success"
  #     redirect_to client_root_path
  #   else
  #     flash[:alert] = "Account Exist or Password input is invalid"
  #     redirect_to new_client_user_session_path
  #   end
  #
  #
  #   # flash[:alert] = "Email exist"
  #   # redirect_to new_client_user_registration_path
  # end


  # GET /resource/edit
  def edit
    render 'devise/registrations/edit'
  end

  # PUT /resource
  def update
    @client_user = current_client_user

    if @client_user.valid_password?(params[:client_user][:current_password])
      update_params = {}
      update_params[:username] = params[:client_user][:username] if params[:client_user][:username].present?
      update_params[:image] = params[:client_user][:image] if params[:client_user][:image].present?

      if params[:client_user][:password].present? && params[:client_user][:password] == params[:client_user][:password_confirmation]
        update_params[:password] = params[:client_user][:password]
        if @client_user.update(update_params)
          flash[:notice] = 'Update Success'
          redirect_to new_client_user_session_path and return
        end
      elsif @client_user.update(update_params)
        flash[:notice] = 'Update Success'
        redirect_to client_root_path and return
      end

      flash[:alert] = @client_user.errors.full_messages.to_sentence
    else
      flash[:alert] = 'Invalid password'
    end

    redirect_to edit_client_user_registration_path
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

  # def set_client_username
  #   @client_username = User.client.find_by(username: params[:client_user][:username])
  # end
  def user_params
    params.require(:client_user).permit(:email, :password)
  end

  def store_promoter
    if params[:promoter].present?
      cookies[:promoter] = params[:promoter]
    end
  end

  protected

  def after_sign_up_path_for(resource)
    client_root_path
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


  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
