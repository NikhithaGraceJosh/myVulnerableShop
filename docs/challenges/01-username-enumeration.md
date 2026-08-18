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

Worked out an answer? Check it against [solutions/01-username-enumeration.md](solutions/01-username-enumeration.md).
