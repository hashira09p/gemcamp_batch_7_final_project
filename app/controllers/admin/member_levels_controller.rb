class Admin::MemberLevelsController < AdminApplicationController
  before_action :set_params, only: [:create, :update]
  before_action :set_member_level, only: [:edit, :update, :destroy]
  def index
    @member_levels = MemberLevel.all
  end

  def new
    @member_level = MemberLevel.new
  end

  def edit
    @meber_level
  end

  def create
    @member_level = MemberLevel.new(set_params)
    if @member_level.save
      flash[:notice] = 'Member Level was successfully created.'
      redirect_to member_levels_path
    else
      flash[:alert] = 'Failed to Create Member Level'
      redirect_to new_member_level_path
    end
  end

  def update
    if @member_level.update(set_params)
      flash[:notice] = 'Member Level was successfully updated.'
      redirect_to member_levels_path
    else
      flash[:alert] = 'Failed to update Member Level'
      redirect_to edit_member_level_path
    end
  end

  def destroy
    if @member_level.destroy
      flash[:notice] = 'Succesfully deleted'
    else
      flash[:alert] = @member_level.errors.full_messages.to_sentence
    end
    redirect_to member_levels_path
  end

  private

  def set_params
    params.require(:member_level).permit(:level, :required_members, :coins)
  end

  def set_member_level
    @member_level = MemberLevel.find(params[:id])
  end
end