class Client::AddressesController < ApplicationController

  before_action :find_user_address, only: [:index, :create]
  def index
    @addresses
  end

  def new
    @address = Address.new
  end

  def create
    if @addresses.count == 5
      flash[:alert] = 'you have reached 5 address input'
      redirect_to new_address_path
    else
      address = Address.new(address_params)
      address.user = current_client_user

      if address.save
        flash[:notice] = 'Succesfully added'
        redirect_to addresses_path
      else
        flash[:alert] = 'failed to add'
        redirect_to new_address_path
      end
    end


  end

  private

  def find_user_address
    @addresses = Address.where(user_id: current_client_user)
  end

  def address_params
    params.require(:address).permit(:genre, :name, :street_address, :phone_number, :remark, :is_default, :address_region_id, :address_province_id, :address_city_id, :address_barangay_id)
  end
end