class Client::AddressesController < ApplicationController
  before_action :set_address, only: [:edit, :update, :destroy]
  before_action :find_user_address, only: [:index, :create]

  def index
    @addresses
  end

  def new
    @address = Address.new
  end

  def edit
    @address
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
        flash[:alert] = 'The phone number must have 11 digits'
        redirect_to new_address_path
      end
    end
  end

  def update
    if @address.update(address_params)
      flash[:notice] = 'Succesfully updated'
      redirect_to addresses_path
    end
  end


  def destroy
    if @address.destroy
      redirect_to addresses_path
    end
  end

  private

  def set_address
    @address = Address.find(params[:id])
  end
  def find_user_address
    @addresses = Address.where(user_id: current_client_user)
  end

  def address_params
    params.require(:address).permit(:genre, :name, :street_address, :phone_number, :remark,
                                    :is_default, :address_region_id, :address_province_id, :address_city_id,
                                    :address_barangay_id)
  end
end