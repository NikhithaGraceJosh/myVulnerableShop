# Solution: Challenge 2 – Weak Password Reset Token

Challenge: [../02-weak-password-reset-token.md](../02-weak-password-reset-token.md)

**Step 1 — trigger a reset and look at the token.**

1. Visit `/users/password/new`.
2. Submit an account you control (or sign up a new one).
3. In development, `config.action_mailer.default_url_options` is set so the reset
   email is fully generated even though delivery is suppressed — check the Rails
   server log for the `Devise::Mailer#reset_password_instructions` line, which
   includes the full link:

   ```text
   /users/password/edit?reset_password_token=<64 hex characters>
   ```

4. Request a second reset for the *same* account and compare. The token is
   identical every time — a truly random token would differ on every request.

**Step 2 — test whether the token is just a hash of the email.**

A 64-character hex string is exactly what a SHA-256 digest looks like. Rather than
guessing blindly, try the obvious candidate input: the account's own email address,
run through any online SHA-256 encoder.

<details>
<summary>Walkthrough</summary>

Paste `admin@domain.com` into a SHA-256 generator:

```text
input:  admin@domain.com
sha256: ccf1903b783419fb838a945e05c147dfb4ea3bdbcfd61cca6ada1f89a9848146
```

Compare that against the token captured in Step 1 — they're identical. The token
isn't random at all; it's `SHA256(email)`. Same email in, same token out, every
time, for anyone who computes it — no access to the reset email required.

**Step 3 — replay the password-change request through Burp with the computed token.**

1. With Burp's proxy running and your browser configured to route through it, open
   `/users/password/edit?reset_password_token=ccf1903b783419fb838a945e05c147dfb4ea3bdbcfd61cca6ada1f89a9848146`
   and fill in a new password on the "Change your password" form. Submit it.
2. In **Proxy → HTTP history**, find the `PUT /users/password` request the form
   submission generated and send it to **Repeater**.
3. In Repeater, confirm the body already contains
   `user[reset_password_token]=ccf1903b783419fb838a945e05c147dfb4ea3bdbcfd61cca6ada1f89a9848146`
   (edit it here if you want to swap in a different account's token) along with
   `user[password]` and `user[password_confirmation]`.
4. Click **Send**. The response is a `303` redirecting to sign-in — the password has
   been changed.

**Step 4 — log in to confirm the takeover.**

1. Send the sign-in page request to Repeater, or just use the browser you already
   have proxied through Burp.
2. Submit `admin@domain.com` with the new password you just set.
3. A `303` redirect (or landing on the signed-in homepage) confirms the takeover —
   you're in as `admin@domain.com` without ever having known its original password.
   That's the challenge: there's no separate flag to collect.

</details>

## Why is this vulnerable?

A password reset token is a bearer credential: whoever presents it can take over the
account, no password required. It must therefore be unpredictable to anyone except
the legitimate recipient of the reset email. Deriving it from public or guessable
data — an email address, a user ID, a username, a timestamp — throws that property
away. The token here is 64 hex characters, which *looks* like a secure random value
at a glance, but its length says nothing about its entropy: `SHA256(email)` has
exactly as much unpredictability as the email address itself, which for a known or
enumerable account is zero.

Combined with username enumeration (Challenge 1), this turns "find a valid account"
directly into "take over that account" with no interaction from the victim at all.

## Real-world mitigation

Don't replace Devise's token generator. `Devise.token_generator.generate` already
produces a fresh `Devise.friendly_token` — cryptographically random, unique per
request — and digests it before storing it, so even the database copy isn't the
usable token. Leave `set_reset_password_token` unoverridden, or if a custom
implementation is required, make sure it:

- Uses a CSPRNG (`SecureRandom`), never a deterministic hash of known attributes
- Generates a new value on every reset request
- Is single-use and invalidated once the password is changed
- Expires quickly (`config.reset_password_within`, already set to 6 hours here)
