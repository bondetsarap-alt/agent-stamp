# Agent ID Hackathon — submission draft

Fill the bracketed fields after deployment, then the user files it during the
Submission Period (until 2026-12-09 08:00 UTC) and confirms before sending.

**Channel hunt (19 Nov 2026):** no public web form exists. The announcement
links only the Promotion survey (app.binance.com/uni-qr/user-survey/
ff6832f8d2984af289068c9450a3c98c — that one is for X-post links, needs a
Binance login). The project submission is most likely inside the Binance app
(Wallet campaign page for the hackathon) — user to open it and screenshot the
form; all fields below are ready to paste.

- **Project name:** Agent Stamp
- **Website:** https://bondetsarap-alt.github.io/agent-stamp/
- **Contract address (BNB Chain):** 0xc44668E726B5eb68760516A9214939E0323D5e6F (deployed 19 Nov 2026, tx 0x49e8ea1e356fbff0eeee6cc57f5786f4ea263e122cc180cb6623a3a4158c97a1; deployer call from the agent wallet via the canonical CREATE2 factory; first claim = stamp #1 by karh.ai's wallet, tx 0xb0ba62e6c56db44dc495d7ba4555f120be8cc6c11e7eb472258ed8547aa7383d)
- **Source code:** https://github.com/bondetsarap-alt/agent-stamp — Sourcify exact-match verified (surfaces on BscScan's code tab)
- **Reward receiving address:** 0xe0067EB565df203601951E7F10644CD7D798a001 (agent wallet, karh.ai)

## Agent ID usage description

Agent Stamp is a free, soulbound stamp that only Agent ID holders can claim.
The contract's single core function, `claim()`, performs a live on-chain
check against the official Agent ID contract
(0x60b9262456de011f7d15a54cdd8c48baaa8b022f): a wallet that does not hold an
Agent ID at claim time is rejected by the contract itself. Agent ID is
therefore not a cosmetic integration — it is the product's access control,
identity check, and eligibility rule.

Each Agent ID holder can claim exactly one stamp, ever. The stamp carries a
sequential number, fully on-chain SVG artwork and metadata, and is
non-transferable (soulbound), making it a durable public proof that its
holder was part of the Agent ID ecosystem. A public counter shows how many
agents have been stamped.

The contract has no owner, no admin functions, no fees and no approvals, and
can never move user assets. Source code is MIT-licensed and verified.

## Why it fits the judging criteria

- **Agent ID application depth (30%)** — eligibility is enforced by the
  Agent ID contract on-chain, not by a server or allowlist.
- **Practicality & feasibility (25%)** — gives every Agent ID an immediate,
  visible use: a shared, growing registry of verified agents.
- **Product completion (25%)** — live contract + live website; claim works
  end-to-end in the Binance Wallet browser.
- **Innovation (20%)** — turns a name service into a proof-of-agent
  collectible: soulbound, sequential, fully on-chain art.

## Interaction target

Innovation Award eligibility needs ≥30 distinct Agent ID addresses
interacting with the contract during the Submission Period. Claim is free
(gas only), one tap from the website.

---

## X post draft (Promotion Campaign, $2,000 / 20 winners)

Post from @Bonbondd_ after the site is live; then submit the post link via
the official campaign survey. Hashtags required: #BinanceWalletHackathon
#AgenticWallet

> Agent Stamp is live 🛂
> A free soulbound stamp only Agent ID holders can claim — checked on-chain. No fees, no approvals, no owner.
> Holders: claim & reply your stamp number.
> Claim: https://bondetsarap-alt.github.io/agent-stamp/
> #BinanceWalletHackathon #AgenticWallet

(Short version fits the 280-char limit of the user's unverified X account —
confirmed 19 Nov; the earlier long draft didn't fit.)

**POSTED 19 Nov 2026 ±14:47 WIB:** https://x.com/Bonbondd_/status/2123322216599441822
Note: the post's Claim link points at the GitHub repo (which links onward to
the site) instead of the site directly — fixed by a self-reply with the site
link. Next: file this post link via the campaign survey (Promotion award).

(Reminder: the promotion award is judged on post quality; never promise
returns in any post — prohibited by the campaign rules.)
