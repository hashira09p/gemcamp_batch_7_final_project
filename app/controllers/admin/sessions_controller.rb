class Admin::SessionsController < Devise::SessionsController

  def new
    super
  end

  def create
    user_admin = User.admin.find_by(email: params[:admin_user][:email])
    if user_admin
      super
      flash[:alert] = "Welcome, #{user_admin.username}"
    elsif user_admin.nil?
      flash[:alert] = 'Invalid Input or account is not an admin.'
      redirect_to new_admin_user_session_path
    end
  end
end