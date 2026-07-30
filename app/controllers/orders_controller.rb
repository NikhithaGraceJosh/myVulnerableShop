# frozen_string_literal: true

class OrdersController < ApplicationController
  def index
    if user_signed_in?
      if current_user.admin?
        if params[:value] == 'all'
          @orders = Order.all
        else
          status_id = Status.find_by(name: params[:value]).id
          @orders = Order.left_outer_joins(:order_statuses).where(order_statuses: { id: OrderStatus.select('MAX(id)').group(:order_id), status_id: status_id })

        end
        @orders = @orders.order(params[:sort] + ' ' + params[:direction])
        if params[:direction] == 'asc'
          @arrow_icon = 'sort-up'
        elsif params[:direction] == 'desc'
          @arrow_icon = 'sort-down'
        end
      else

        render '/error/unauthorised', layout: 'error_layout'
      end
    else
      flash[:error] = 'Please sign in to access this page'
      redirect_to new_user_session_path
    end
  end

  def create
    if params[:post].nil?
      flash[:error] = 'Please choose a delivery address.'
      redirect_to summary_cart_path(current_user)
      return
    end

    order_placed = false

    # Wrapped in a transaction so a failure partway through (e.g. an invalid
    # order item) can't leave a half-created Order with no OrderStatus behind.
    ActiveRecord::Base.transaction do
      @order = Order.create!(user_id: current_user.id, address_id: params[:post][:address])
      @cart = ShoppingCart.where(user_id: current_user.id)
      array = generate_array(@cart)
      @order_item = OrderItem.create(array)
      if @order_item.all?(&:valid?)
        update_stock_quantity(@cart)
        ShoppingCart.where(user_id: current_user.id).destroy_all
        @order.update!(amount: calculate_order_total(@order_item))
        status = Status.find_by(name: 'Awaiting Payment')
        @order_status = OrderStatus.create!(order_id: @order.id, status_id: status.id)
        order_placed = true
      else
        raise ActiveRecord::Rollback
      end
    end

    if order_placed
      OrderMailer.order_email(current_user, @order).deliver_now
      flash[:notice] = 'Your order has been successfully placed. We have sent an email with your order details to your registered email.'
      redirect_to new_payment_path(order_id: @order.id)
    else
      render 'cart/show'
    end
  end

  def show
    if user_signed_in?
      @order = Order.find(params[:id])
      @statuses = Status.all
      unless (@order.user_id == current_user.id) || @current_user.admin?
        render '/error/unauthorised', layout: 'error_layout'
      end
    else
      flash[:error] = 'Please sign in to access this page'
      redirect_to new_user_session_path
    end
  end

  def update_order_status
    @status_id = Status.find_by(name: params[:status_name]).id
    @order_status = OrderStatus.create!(order_id: params[:order_id].to_i, status_id: @status_id)
  end

  def destroy; end

  private

  def generate_array(cart)
    array = []
    cart.each_with_index do |item, index|
      hash = {}
      hash['order_id'] = @order.id
      hash['product_id'] = item.product_id
      hash['quantity'] = item.quantity
      hash['size_id'] = item.size_id
      array[index] = hash
    end
    array
  end

  def update_stock_quantity(cart)
    cart.each_with_index do |item, _index|
      @product_size = ProductSize.find_by(product_id: item.product_id, size_id: item.size_id)
      @current_quantity = @product_size.stock_quantity
      @new_quantity = @current_quantity - item.quantity
      if @new_quantity == 0
        @product_size.destroy
      else
        ProductSize.update(@product_size.id, stock_quantity: @new_quantity)
      end
    end
  end

  def calculate_order_total(items)
    total = 0
    items.each do |item|
      total += item.product.price * item.quantity
    end
    total
  end
end
