class Admin::WinnersController < AdminApplicationController
  before_action :set_winner, only: [:submit, :pay, :ship, :deliver, :publish, :remove_publish]
  def index
    @winner_states = Winner.pluck(:state).uniq
    @winners = Winner.includes(:user).page(params[:page]).per(5) # Eager load for performance

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
      @winners = @tickets.where(created_at: params[:start_date]..params[:end_date]).page(params[:page]).per(5)
    end
  end

  def create;end

  def submit
    if @winner.may_submit?
      @winner.submit!
      flash[:notice] = 'Success'
      redirect_to winners_path
    else
      flash[:alert] = @winner.errors.full_messages.to_sentence
      redirect_to winners_path
    end
  end

  def pay #It will redirect to the form which the admin can input the price and the date.
    if @winner.may_pay?
      @winner.update(price: rand(1...99999), paid_at: Time.now.strftime("%Y-%d-%m %H:%M:%S %Z"), admin_id: current_admin_user.id)
      @winner.pay!
      flash[:notice] = 'Success'
      redirect_to winners_path
    else
      flash[:alert] = @winner.errors.full_messages.to_sentence
      redirect_to winners_path
    end
  end

  def ship
    if @winner.may_ship?
      @winner.ship!
      flash[:notice] = 'Success'
      redirect_to winners_path
    else
      flash[:alert] = @winner.errors.full_messages.to_sentence
      redirect_to winners_path
    end
  end

  def deliver
    if @winner.may_deliver?
      @winner.deliver!
      flash[:notice] = 'Success'
      redirect_to winners_path
    else
      flash[:alert] = @winner.errors.full_messages.to_sentence
      redirect_to winners_path
    end
  end

  def publish
    if @winner.may_publish?
      @winner.publish!
      flash[:notice] = 'Success'
      redirect_to winners_path
    else
      flash[:alert] = @winner.errors.full_messages.to_sentence
      redirect_to winners_path
    end
  end

  def remove_publish
    if @winner.may_remove_publish?
      @winner.remove_publish!
      flash[:notice] = 'Success'
      redirect_to winners_path
    else
      flash[:alert] = @winner.errors.full_messages.to_sentence
      redirect_to winners_path
    end
  end

  private

  def set_winner
    @winner = Winner.find(params[:winner_id])
  end
end