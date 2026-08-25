# Challenge 2 – Weak Password Reset Token

## Difficulty

🟢 Easy

## Category

Authentication

## Prerequisite

[Challenge 1 – Username Enumeration](01-username-enumeration.md)

Challenge 1 walks through how to confirm `admin@domain.com` as a valid account — the
target for this challenge.

## Scenario

The application lets a user request a password reset by submitting their email
address. It emails them a link containing a reset token; visiting that link lets them
set a new password.

Your task is to determine whether the reset token can be predicted or manipulated
without ever receiving the email.

## Objective

Using the account confirmed in Challenge 1, reset the password of:

```text
admin@domain.com
```

without knowing its current password, then log in as that account. Successfully
signing in with the password you set is the challenge — there's no separate flag to
collect.

## Learning Goals

After completing this challenge you should understand:

- Why a password reset token must be unguessable, not just unique
- How deriving a token deterministically from public data defeats that guarantee
- How to read Rails/Devise source to find where a framework default has been overridden
- Why "long token" and "random token" are not the same property

## Hints

<details>
<summary>Hint 1 — Look at the reset URL</summary>

Request a password reset for an account you control (or sign up a new one) and
inspect the link that would be generated. What does the token look like, and how long
is it?

</details>

<details>
<summary>Hint 2 — Compare tokens</summary>

Request a reset more than once for the same account. Do you get a different token
each time, or the same one?

</details>

<details>
<summary>Hint 3 — Look at the source</summary>

This is a deliberately vulnerable app — don't assume Devise's default token
generator is still in use. Search the codebase for where `reset_password_token` is
produced.

</details>

<details>
<summary>Hint 4 — What do you already know?</summary>

From Challenge 1, you know how to confirm a valid account email. What single piece of
information about that account might be enough to derive its token?

</details>

<details>
<summary>Hint 5 — You shouldn't need to brute-force anything</summary>

If the token is a deterministic function of something public (like the email
address), you can compute it yourself, offline, without ever triggering a reset
email.

</details>

## Solution

Worked out an answer? Check it against
[solutions/02-weak-password-reset-token.md](solutions/02-weak-password-reset-token.md).
