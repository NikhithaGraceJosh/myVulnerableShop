# Challenge 1 – Username Enumeration

## Difficulty

🟢 Easy

## Category

Authentication

## Scenario

The application allows users to request a password reset by entering their email address.

Like a real attacker doing reconnaissance before a credential-stuffing or phishing campaign, your task is to first put together a *candidate* email address from public information on the site, then confirm whether it actually has an account — without knowing any password, and without direct access to the database.

## Objective

Find one email address that is confirmed to be registered in the shop.

## Learning Goals

After completing this challenge you should understand:

- How real recon (a name, a support address, a naming convention) produces the candidates an enumeration oracle is used against
- Why revealing account existence for a candidate is dangerous
- How attackers enumerate valid users
- How frameworks like Devise mitigate this

## Hints

<details>
<summary>Hint 1</summary>

You need a candidate email before you can check anything. The site's own footer mentions both a name and a support address — what domain does the shop use for email, and who runs the site?

</details>

<details>
<summary>Hint 2</summary>

Combine the name with the domain you found, the way a company's email addresses are usually formed, then check that guess.

</details>

<details>
<summary>Hint 3</summary>

Compare the application's response for your candidate against an email you make up. Look at the response body, status code, redirect, or flash message on the password reset flow.

</details>

## Solution

**Step 1 — build a candidate from public information.**

The footer on every page of the shop reads:

> Cherries Boutique · Need help with your order? Email our support team at support@domain.com
> Site managed by Admin

That's two pieces of real recon: the shop's email domain is `domain.com`, and the site is credited to "Admin". Following the same `name@domain` convention as the support address, a reasonable candidate is `admin@domain.com`.

**Step 2 — confirm it with the oracle.**

1. Visit `/users/password/new`.
2. Submit an email address you know does not exist and record the response.
3. Submit the candidate, `admin@domain.com`, and compare.
4. Notice the application reveals whether an account exists.

<details>
<summary>Walkthrough</summary>

Submitting a **made-up** email:

```bash
curl -i -X POST http://localhost:3000/users/password \
  -F "authenticity_token=<token>" \
  -F "user[email]=doesnotexist@nowhere.test"
```

returns **HTTP 422** and re-renders the form with the error message `Email not found`.

Submitting the **candidate** from Step 1:

```bash
curl -i -X POST http://localhost:3000/users/password \
  -F "authenticity_token=<token>" \
  -F "user[email]=admin@domain.com"
```

returns **HTTP 303**, redirects to the sign-in page, and shows the generic flash message "You will receive an email with instructions on how to reset your password in a few minutes."

Both the HTTP status code and the message content differ between the two cases — that difference is the oracle. Given any candidate email (built from a name and a known domain, pulled from a breach corpus, guessed as a common role address, scraped off LinkedIn, etc.), it tells an attacker with certainty whether the account exists.

**Confirmed answer for this challenge:** `admin@domain.com` is a registered account.

</details>

## Why is this vulnerable?

Returning different responses for existing and non-existing users turns the password reset form into an oracle: given any candidate address, an attacker learns for free whether it has an account. Combined with a name and a domain pulled straight off the site's own footer, this is how attackers turn a little public information into a confirmed valid account for password spraying, credential stuffing, or phishing.

## Real-world mitigation

Enable Devise's paranoid mode so password reset requests always return the same generic response regardless of whether the account exists:

```ruby
# config/initializers/devise.rb
config.paranoid = true
```

With paranoid mode on, Devise always responds with the same status code, message ("If your email address exists in our database, you will receive a password recovery link..."), and timing characteristics, whether or not the account exists — closing off the enumeration channel entirely.
