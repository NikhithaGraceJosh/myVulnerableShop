# frozen_string_literal: true

class CartController < ApplicationController
  def show
    if user_signed_in?
      if current_user.customer? && params[:id].to_i == current_user.id
        @cart = ShoppingCart.where(user_id: current_user.id).order(id: :asc)
        @total_price = 0
        @cart.map { |x| @total_price += x.product.price * x.quantity }
        @address = Address.new
        @order_items = OrderItem.new
      else
        render '/error/unauthorised', layout: 'error_layout'
      end
    else
      flash[:error] = 'Please sign in to access this page'
      redirect_to new_user_session_path

    end
  end

  def update_user_cart
    @cart_item = ShoppingCart.find(params[:id])

    @item = is_present_in_cart(@cart_item.product_id, params[:size_id])
    if @item.nil?
      success = @cart_item.update(size_id: params[:size_id], quantity: params[:quantity])
      @errors = @cart_item.errors
    else

      if params[:update_quantity_only] == 'true'
        success = @item.update(quantity: params[:quantity].to_i)
      else
        success = @item.update(quantity: params[:quantity].to_i + @item.quantity)
        @cart_item.destroy if success
      end
      @errors = @item.errors
      @cart_item = @item
    end
    @cart_item = ShoppingCart.find(params[:id]) unless success
    @cart = ShoppingCart.where(user_id: current_user.id).order(id: :asc)
    @total_price = 0
    @cart.map { |x| @total_price += x.product.price * x.quantity }

    respond_to do |format|
      format.js { render '/cart/update_cart_list.js.erb' }
    end
  end

  def destroy
    if user_signed_in?
      if current_user.customer?
        @cart = ShoppingCart.find(params[:id])
        @cart.destroy
        redirect_to cart_path(current_user.id)
      else
        render '/error/unauthorised', layout: 'error_layout'
      end
    else
      flash[:error] = 'Please sign in to access this page'
      redirect_to new_user_session_path
    end
  end

  def summary
    @cart = ShoppingCart.where(user_id: current_user.id)
  end

  private

  def is_present_in_cart(pid, sid)
    ShoppingCart.find_by(product_id: pid, size_id: sid)
  end
end
