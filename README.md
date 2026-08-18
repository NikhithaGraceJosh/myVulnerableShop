# myVulnerableShop

## Setup

Requirements: Ruby 3.4.5 and a MySQL (or MariaDB) server.

```bash
git clone <this repo>
cd myVulnerableShop
bin/setup
```

`bin/setup` installs gems, creates the `rails`/`password` MySQL user expected by
[config/database.yml](config/database.yml) if it doesn't already exist, then prepares
(creates, migrates, seeds) the development and test databases. It's safe to re-run at
any time.

Then start the app:

```bash
bin/dev            # Rails server + Dart Sass watcher (recommended)
# or
bin/rails server   # Rails server only
```

Visit `http://localhost:3000` and sign in with the seeded admin account:

- email: `admin@domain.com`
- password: `password`

Payments work out of the box without any configuration — see
[Payments](#payments-stripe-is-optional) below if you want real Stripe checkout.

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