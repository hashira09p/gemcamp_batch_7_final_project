class Admin::SessionsController < Devise::SessionsController

  # def new
  #   render 'devise/sessions/admin/new'
  # end

  def create
    user_admin = User.admin.find_by(email: params[:admin_user][:email])
    if user_admin
      super
      flash[:alert] = "Welcome, #{user_admin.username}"
    elsif user_admin.nil?
      flash[:alert] = user_admin.errors.full_messages.to_sentence
      redirect_to new_admin_user_session_path
    end
  end
end