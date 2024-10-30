class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  #def new
  #super
  #end

  # POST /resource/sign_in
   def create
     user = User.client.find_by(email: params[:user][:email])
     if user.present?
       sign_in(resource_name, user)
       redirect_to client_root_path
     else
       redirect_to new_user_session_path
     end
   end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
