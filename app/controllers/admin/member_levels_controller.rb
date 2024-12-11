class Admin::MemberLevelsController < AdminApplicationController

  def index
    @member_levels = MemberLevel.includes(:client)
  end
end