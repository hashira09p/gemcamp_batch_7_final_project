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

    @all_clients = User.where(role: 'client')
                       .where.not(parent: nil)
                       .order(created_at: :desc)


    respond_to do |format|
      format.html
      format.csv do
        csv_string = CSV.generate do |csv|
          csv << [
            User.human_attribute_name(:parent_email),
            User.human_attribute_name(:email),
            User.human_attribute_name(:total_deposit),
            User.human_attribute_name(:member_total_deposit),
            User.human_attribute_name(:coins),
            User.human_attribute_name(:coins_used_count),
            User.human_attribute_name(:children_members)
          ]

          @all_clients.each do |client|
            csv << [
              client.parent.email,
              client.email,
              client.total_deposit,
              client.children.present? ? client.children.sum { |child| child.total_deposit || 0 } : 0,
              client.coins,
              view_context.total_used_coins(
                client.total_deposit,
                client.coins,
                client.orders.where(genre: ['increase', 'bonus', 'share', 'member_level'], state: 'paid')
                      .sum(:coin)),
              client.children_members
            ]
          end
        end

        render plain: csv_string
      end
    end
  end
end