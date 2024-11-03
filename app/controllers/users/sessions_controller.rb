class Users::SessionsController < Devise::SessionsController
  before_action :set_resource_name
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
   def create
     user = User.client.find_by(email: params[:user][:email])
     if user
       flash[:alert] = "Welcome, #{user.username}"
       redirect_to client_index_path
     elsif user.nil?
       flash[:alert] = 'Invalid Input or account is not an client.'
       render :new
     end
   end

  # DELETE /resource/sign_out
  # def destroy
  #   render :new
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
  private

  def set_resource_name
    @resource_name = :user
  end
end
