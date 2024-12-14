class Admin::TicketsController < AdminApplicationController
  def index
    @all_tickets = Ticket.all
    @ticket_states = Ticket.pluck(:state).uniq
    @tickets = Ticket.includes(:item, :user).page(params[:page]).per(5) # Eager load for performance

    if params[:serial_number].present?
      @tickets = @tickets.where('LOWER(serial_number) LIKE ?', "%#{params[:serial_number].downcase}%")
                         .page(params[:page]).per(5)
    end

    if params[:item_name].present?
      @tickets = @tickets.joins(:item).where('LOWER(items.name) LIKE ?', "%#{params[:item_name].downcase}%")
                         .page(params[:page]).per(5)
    end

    if params[:email].present?
      @tickets = @tickets.joins(:user).where('LOWER(users.email) LIKE ?', "%#{params[:email].downcase}%")
                         .page(params[:page]).per(5)
    end

    if params[:state].present?
      @tickets = @tickets.where(state: params[:state])
                         .page(params[:page]).per(5)
    end

    if params[:start_date].present? && params[:end_date].present?
      @tickets = @tickets.where(created_at: params[:start_date]..params[:end_date])
                         .page(params[:page]).per(5)
    end

    respond_to do |format|
      format.html
      format.csv do
        csv_string = CSV.generate do |csv|
          csv << [
            Ticket.human_attribute_name(:ticket_id),
            Ticket.human_attribute_name(:item_id),
            Ticket.human_attribute_name(:item_name),
            Ticket.human_attribute_name(:user_email),
            Ticket.human_attribute_name(:batch_count),
            Ticket.human_attribute_name(:coins),
            Ticket.human_attribute_name(:state),
            Ticket.human_attribute_name(:serial_number),
            Ticket.human_attribute_name(:created_at)
          ]

          @all_tickets.each do |ticket|
            csv << [
              ticket.id,
              ticket.item.id,
              ticket.item.name,
              ticket.user.email,
              ticket.batch_count,
              ticket.coins,
              ticket.state,
              ticket.serial_number,
              ticket.created_at
            ]
          end
        end

        render plain: csv_string
      end
    end
  end
end