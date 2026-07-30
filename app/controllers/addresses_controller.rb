# frozen_string_literal: true

class AddressesController < ApplicationController
  def create
    @address = Address.new(address_params)
    @address.user = current_user
    if @address.save
      redirect_to summary_cart_path(current_user)
    else
      respond_to do |format|
        format.json { render json: { error: @address.errors.full_messages }, status: 422 }
      end
   end
  end

  private

  def address_params
    params.require(:address).permit(:street, :city, :zip)
  end
end
