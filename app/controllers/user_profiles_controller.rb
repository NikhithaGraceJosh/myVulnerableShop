# frozen_string_literal: true

class UserProfilesController < ApplicationController
  def show
    if user_signed_in?

      if params[:id].to_i == current_user.id
        @user = User.find(params[:id])
        if @user.image.nil?

          @user.build_image

          @url = '/images'
        else
          @url = '/images/' + @user.image.id.to_s
        end
      else
        render 'error/unauthorised', layout: 'error_layout'
      end
    else
      flash[:error] = 'Please sign in to access this page'
      redirect_to new_user_session_path
    end
  end

  def edit_profile
    @user = User.find(params[:id])
  end

  def update_profile
    @user = User.find(params[:id])
    if @user.update(profile_params)
      redirect_to user_profile_path
    else
      render 'edit_profile'
    end
  end

  def update_cart
    if user_signed_in?
      @product = Product.find(params[:id])
      @cart_item = ShoppingCart.find_by(product_id: @product.id, size_id: params[:size_id], user_id: current_user.id)
      if @cart_item.nil?
        @cart_item = ShoppingCart.new(product_id: @product.id, user_id: current_user.id, quantity: params[:quantity], size_id: params[:size_id])
      else

        @ps = ProductSize.find_by(product_id: @product.id, size_id: params[:size_id])
        if @ps.stock_quantity < params[:quantity].to_i
          flash[:error] = 'Not Enough Stock! Only ' + @ps.stock_quantity.to_s + ' left!'
          render 'cart/show' && return
        else

          if @ps.stock_quantity > @cart_item.quantity + params[:quantity].to_i
            @cart_item.quantity = @cart_item.quantity + params[:quantity].to_i
            if @cart_item.quantity > 5
              flash[:error] = 'Sorry. Cant purchase more than 5 of the same product'
              @cart_item.quantity = 5
            end
          else
            @cart_item.quantity = @ps.stock_quantity
          end
        end
      end

      if @cart_item.save
        redirect_to cart_path(current_user)
      else
        @sizes = Size.all
        render 'products/show', status: :unprocessable_entity
      end
    else
      flash[:error] = 'Please sign in to add to cart'

      redirect_to new_user_session_path
    end
  end

  def list_user_orders
    if user_signed_in?
      if current_user.customer?
        @orders = current_user.orders.order(id: :desc)
      else
        render '/error/unauthorised', layout: 'error_layout'
      end
    else
      flash[:error] = 'Please sign in to access this page'
      redirect_to new_user_session_path
    end
  end

  private

  def profile_params
    params.require(:user).permit(:name, :phone, :email, addresses_attributes: %i[street city zip id _destroy])
  end
end
