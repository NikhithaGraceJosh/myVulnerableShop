# frozen_string_literal: true

class StripeChargesService
  DEFAULT_CURRENCY = 'usd'

  def initialize(params, user)
    @stripe_name = params[:name]
    @stripe_token = params[:stripeToken]
    @order = params[:order_id]
    @user = user
  end

  def call
    create_charge
  end

  private

  attr_accessor :user, :stripe_email, :stripe_token, :order

  def create_charge
    @payment_method = Stripe::PaymentMethod.create(
      type: 'card',
      card: {
        token: @stripe_token
      }
    )
    Stripe::PaymentIntent.create(
      amount: order_amount,
      currency: DEFAULT_CURRENCY,
      payment_method_types: ['card'],
      payment_method: @payment_method.id,
      receipt_email: @user.email
    )
  end

  def order_amount
    Order.find_by(id: order.to_i).amount
  end
end
