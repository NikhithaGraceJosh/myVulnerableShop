# frozen_string_literal: true

# Stripe is optional. When STRIPE_SECRET_KEY/STRIPE_PUBLISHABLE_KEY are unset,
# PaymentsController falls back to FakePaymentService and no key is required.
# See README.md for how to enable real Stripe checkout.
Rails.configuration.stripe = {
  publishable_key: ENV['STRIPE_PUBLISHABLE_KEY'],
  secret_key: ENV['STRIPE_SECRET_KEY']
}

Stripe.api_key = ENV['STRIPE_SECRET_KEY']
