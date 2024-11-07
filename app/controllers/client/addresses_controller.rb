class Client::AddressesController < ApplicationController
  def index;end

  def new
    @address = Address.new
  end

  def create
    address = Address.new()
  end

  private

  def address_params
    params.required(:address).permit(:name, :street_number, :phone_number, :remark, :is_default, :current_user, :address_region_id, :address_provinces_id, :address_city_id, :address_barangay_id)
  end
end