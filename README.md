# Agent Stamp

A free, soulbound stamp that **only Agent ID holders can claim** — one per
address, forever.

Agent ID is the on-chain identity of a Binance Agentic Wallet (a `name.ai`
name, issued by SPACE ID on BNB Chain). Agent Stamp turns that identity into
a collectible proof: if your wallet holds an Agent ID, you can claim your
stamp. If it doesn't, the contract rejects the claim.

- **Network:** BNB Chain (BSC, chain id 56)
- **Agent ID contract:** `0x60b9262456de011f7d15a54cdd8c48baaa8b022f`
- **Cost:** free — you only pay your own gas
- **Transferable:** no (soulbound; every transfer/approval path reverts)
- **Admin:** none. No owner, no fees, no approvals, nothing to withdraw.
  The Agent ID address is fixed in the constructor at deployment.

## How it works

`claim()` checks `agentId.balanceOf(msg.sender) > 0` on the real Agent ID
contract, enforces one stamp per address, and mints the next sequential
stamp with a fully on-chain SVG artwork and metadata (no IPFS, no server).

## Build & test

```sh
forge build
forge test
```

Built with Foundry, Solidity 0.8.26. MIT licensed.

## Entry

Built for the Binance Wallet × BNB Chain **Agent ID Hackathon**
(submission period 18 Nov – 9 Dec 2026).
