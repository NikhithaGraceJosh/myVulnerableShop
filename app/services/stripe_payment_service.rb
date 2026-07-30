# frozen_string_literal: true

class StripePaymentService
  def charge(charge_params, user, return_url:)
    payment = StripeChargesService.new(charge_params, user).call
    Stripe::PaymentIntent.confirm(payment.id, return_url: return_url)
  end

  def retrieve(payment_intent_id)
    Stripe::PaymentIntent.retrieve(payment_intent_id)
  end
end
