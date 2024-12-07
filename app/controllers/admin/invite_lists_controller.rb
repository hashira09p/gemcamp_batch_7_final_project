class Admin::InviteListsController < AdminApplicationController
  def index
    @clients = User.where(role: 'client')
                   .where.not(parent: nil)
                   .order(created_at: :desc)
                   .page(params[:page]).per(10)

    if params[:item_name].present?
      @clients = @clients.joins(:user).where('LOWER(parent.email) LIKE ?', "%#{params[:parent_email].downcase}%")
                         .page(params[:page]).per(5)
    end
  end
end