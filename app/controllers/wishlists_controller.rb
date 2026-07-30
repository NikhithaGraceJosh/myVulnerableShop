# frozen_string_literal: true

class WishlistsController < ApplicationController
  protect_from_forgery except: %i[create destroy]

  def create
    @wishlist = Wishlist.find_or_create_by(user_id: current_user.id, product_id: params[:product_id])
    redirect_to wishlist_path(current_user)
  end

  def show
    @wishlist = Wishlist.where(user_id: current_user.id)
  end

  def destroy
    @wishlist = Wishlist.find_by(user_id: current_user.id, product_id: params[:id])
    @wishlist.destroy
  end
end
