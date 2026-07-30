# frozen_string_literal: true

# Stand-in for StripePaymentService so the app runs without Stripe API keys.
# Always "succeeds" immediately -- no card is validated and no network call is made.
class FakePaymentService
  FakeIntent = Struct.new(:id, :status, :next_action, :last_payment_error)

  def charge(_charge_params, _user, return_url: nil)
    FakeIntent.new("fake_pi_#{SecureRandom.hex(12)}", 'succeeded', nil, nil)
  end

  def retrieve(payment_intent_id)
    FakeIntent.new(payment_intent_id, 'succeeded', nil, nil)
  end
end
