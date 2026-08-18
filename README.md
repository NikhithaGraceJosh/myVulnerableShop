# myVulnerableShop

## Security challenges

This app ships with intentional vulnerabilities to practice against, CTF-style. See
[docs/challenges](docs/challenges/README.md) for the list of challenges and their writeups.

## Payments (Stripe is optional)

By default this app runs without any Stripe account or API keys. Checkout uses a
`FakePaymentService` that immediately marks the order as paid — no card is validated
and no network call is made — so anyone cloning the repo can run the full app right away.

If you want real Stripe checkout (Stripe Elements card form, 3D Secure redirects, etc.):

1. Create a free [Stripe account](https://dashboard.stripe.com/register) and grab your
   **test mode** API keys from the Stripe Dashboard.
2. Set the following environment variables before starting the server:

   ```bash
   export STRIPE_SECRET_KEY=sk_test_xxxxxxxxxxxx
   export STRIPE_PUBLISHABLE_KEY=pk_test_xxxxxxxxxxxx
   ```

3. Start the app as usual. `PaymentsController` automatically switches to
   `StripePaymentService` whenever `STRIPE_SECRET_KEY` is present.

Never commit real API keys — use Stripe's test keys only.