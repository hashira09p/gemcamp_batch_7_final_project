class Admin::WinnersController < AdminApplicationController
  before_action :set_winner, only: [:submit, :pay, :ship, :deliver, :publish, :remove_publish]
  def index
    @all_winners = Winner.all
    @winner_states = Winner.pluck(:state).uniq
    @winners = Winner.includes(:user).order(created_at: :desc).page(params[:page]).per(10) # Eager load for performance

    if params[:serial_number].present?
      @winners = @winners.where('LOWER(serial_number) LIKE ?', "%#{params[:serial_number].downcase}%")
                         .page(params[:page]).per(5)
    end

    if params[:email].present?
      @winners = @winners.joins(:user).where('LOWER(users.email) LIKE ?', "%#{params[:email].downcase}%")
                         .page(params[:page]).per(5)
    end

    if params[:state].present?
      @winners = @winners.where(state: params[:state]).page(params[:page]).per(5)
    end

    if params[:start_date].present? && params[:end_date].present?
      @winners = @winners.where(paid_at: params[:start_date]..params[:end_date]).page(params[:page]).per(5)
    end

    respond_to do |format|
      format.html
      format.csv do
        csv_string = CSV.generate do |csv|
          csv << [
            Winner.human_attribute_name(:item_name),
            Winner.human_attribute_name(:ticket_owner),
            Winner.human_attribute_name(:user_email),
            Winner.human_attribute_name(:batch_count),
            Winner.human_attribute_name(:state),
            Winner.human_attribute_name(:state),
            Winner.human_attribute_name(:price),
            Winner.human_attribute_name(:paid_at),
            Winner.human_attribute_name(:admin_ID),
            Winner.human_attribute_name(:image),
            Winner.human_attribute_name(:comment)
          ]

          @all_winners.each do |winner|
            csv << [
              winner.item.name,
              winner.user.username,
              winner.user.email,
              winner.item.batch_count,
              winner.state,
              winner.price,
              winner.paid_at,
              winner.admin_id,
              winner.image,
              winner.comment
            ]
          end
        end

        render plain: csv_string
      end
    end
  end

  def create;end

  def submit
    if @winner.may_submit?
      @winner.submit!
      flash[:notice] = 'Success'
      redirect_to winners_path(params[:page])
    else
      flash[:alert] = @winner.errors.full_messages.to_sentence
      redirect_to winners_path(params[:page])
    end
  end

  def pay #It will redirect to the form which the admin can input the price and the date.
    if @winner.may_pay?
      @winner.update(price: rand(1...99999), paid_at: Time.now.strftime("%Y-%d-%m %H:%M:%S %Z"), admin_id: current_admin_user.id)
      @winner.pay!
      flash[:notice] = 'Success'
      redirect_to winners_path(params[:page])
    else
      flash[:alert] = @winner.errors.full_messages.to_sentence
      redirect_to winners_path(params[:page])
    end
  end

  def ship
    if @winner.may_ship?
      @winner.ship!
      flash[:notice] = 'Success'
      redirect_to winners_path(params[:page])
    else
      flash[:alert] = @winner.errors.full_messages.to_sentence
      redirect_to winners_path(params[:page])
    end
  end

  def deliver
    if @winner.may_deliver?
      @winner.deliver!
      flash[:notice] = 'Success'
      redirect_to winners_path(params[:page])
    else
      flash[:alert] = @winner.errors.full_messages.to_sentence
      redirect_to winners_path(params[:page])
    end
  end

  def publish
    if @winner.may_publish?
      @winner.publish!
      flash[:notice] = 'Success'
      redirect_to winners_path(params[:page])
    else
      flash[:alert] = @winner.errors.full_messages.to_sentence
      redirect_to winners_path(params[:page])
    end
  end

  def remove_publish
    if @winner.may_remove_publish?
      @winner.remove_publish!
      flash[:notice] = 'Success'
      redirect_to winners_path(params[:page])
    else
      flash[:alert] = @winner.errors.full_messages.to_sentence
      redirect_to winners_path(params[:page])
    end
  end

  private

  def set_winner
    @winner = Winner.find(params[:winner_id])
  end
end