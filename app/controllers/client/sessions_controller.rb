class Client::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  #def new
  #super
  #end

  # POST /resource/sign_in
   def create
     user = User.client.find_by(email: params[:user][:email])
     if user
       super
       flash[:alert] = "Welcome, #{user.username}"
     elsif user.nil?
       flash[:alert] = 'Invalid Input or account is not an client.'
       render :new
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
