# myVulnerableShop Challenges

A set of intentionally vulnerable, CTF-style challenges built into myVulnerableShop. Each one lives in the running app itself — no separate setup required beyond starting the server (`bin/dev` or `bin/rails server`).

| # | Challenge | Category | Difficulty |
|---|-----------|----------|------------|
| 1 | [Username Enumeration](01-username-enumeration.md) | Authentication | 🟢 Easy |

## How to solve a challenge

Each challenge's writeup states its own objective — sometimes a `flag{...}`, sometimes a specific piece of information to uncover (e.g. a valid account email). There's no separate submission system: read the challenge's hints, reproduce the vulnerable behavior against the running app, and check your result against the "Solution" section in that challenge's writeup.
