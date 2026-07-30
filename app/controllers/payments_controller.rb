# frozen_string_literal: true

class PaymentsController < ApplicationController
  rescue_from Stripe::CardError, with: :catch_exception

  def new
    @order = Order.find(params[:order_id])
    return if params[:payment_intent].nil?

    @payment = payment_service.retrieve(params[:payment_intent])
    if @payment.status == 'succeeded'
      complete_order!
    elsif @payment.status == 'requires_payment_method'
      flash[:error] = @payment.last_payment_error.code + ': ' + @payment.last_payment_error.message
      render 'new'
    end
  end

  def create
    intent = payment_service.charge(
      charges_params,
      current_user,
      return_url: "http://localhost:3000/payments/new?order_id=#{params[:order_id]}"
    )
    if intent.status == 'requires_action'
      redirect_to intent.next_action.redirect_to_url.url if intent.next_action.type == 'redirect_to_url'
    elsif intent.status == 'succeeded'
      complete_order!
    end
  end

  def show; end

  private

  def payment_service
    @payment_service ||= ENV['STRIPE_SECRET_KEY'].present? ? StripePaymentService.new : FakePaymentService.new
  end

  def complete_order!
    OrderStatus.create(order_id: params[:order_id], status_id: Status.find_by(name: 'Awaiting Fulfillment').id)
    flash[:success] = 'Payment successful'
    redirect_to list_user_orders_user_profiles_path
  end

  def charges_params
    params.permit(:name, :stripeToken, :order_id)
  end

  def catch_exception(exception)
    flash[:error] = exception.message
    redirect_to new_payment_path(order_id: params[:order_id])
  end
end
