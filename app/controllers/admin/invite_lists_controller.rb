class Admin::InviteListsController < AdminApplicationController
  def index
    @clients = User.where(role: 'client')
                   .where.not(parent: nil)
                   .order(created_at: :desc)
                   .page(params[:page]).per(10)

    if params[:parent_email].present?
      @clients = User.joins('INNER JOIN users parents ON users.parent_id = parents.id')
                     .where('LOWER(parents.email) LIKE ?', "%#{params[:parent_email].downcase}%")
                     .page(params[:page]).per(5)
    end
  end
end