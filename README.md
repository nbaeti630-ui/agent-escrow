# 🤖 AgentEscrow

**Trustless escrow for the AI agent economy.** Lock funds, verify quality, auto-refund on failure — pay AI agents the safe way.

Built on **Base**. Designed for **Rialo**.

- 🌐 **Live dApp:** https://nbaeti630-ui.github.io/agent-escrow/
- 🔵 **Network:** Base Sepolia (Chain ID 84532)
- 📄 **Contract:** `0x586d683E98d32A22646DebECC1e706753C0079B1`
- ✅ **Verified source:** https://base-sepolia.blockscout.com/address/0x586d683E98d32A22646DebECC1e706753C0079B1

---

## What it does

AgentEscrow is a smart contract that lets anyone pay an AI agent to complete a task — *safely*:

1. **Escrow** — the requester locks the reward on-chain when posting a task.
2. **Deliver** — an agent submits the result before a deadline.
3. **Verify** — a judge checks the work against the agreed terms.
4. **Settle** — pass → the agent is paid instantly; fail or timeout → the requester is refunded automatically.

No upfront trust. No chasing payments. No middleware.

## Contract interface

| Function | What it does |
| --- | --- |
| `createTask(string prompt, address judge, uint256 deadline)` *(payable)* | Lock the reward and open a task |
| `submitWork(uint256 id, string resultURI)` | Agent delivers the result |
| `approveWork(uint256 id)` | Judge approves → reward released to the agent |
| `refundIfExpired(uint256 id)` | Refund the requester after the deadline |

## Try it

1. Open the live dApp: https://nbaeti630-ui.github.io/agent-escrow/
2. Connect a wallet on **Base Sepolia** (grab test ETH from a Base Sepolia faucet).
3. Create a task, submit work, and approve it — every step happens on-chain.

## Tech

- **Solidity** ^0.8.24 — `AgentEscrow.sol`
- **Base Sepolia** testnet
- Single-file frontend (`index.html`) using **ethers.js**, hosted on **GitHub Pages**
- Compiled, deployed & verified via **Remix IDE**

## Roadmap

- [x] Write & deploy the escrow contract to Base Sepolia (source verified)
- [x] Live web dApp (Rialo-themed UI)
- [ ] Automated agent + judge scripts
- [ ] Rialo integration — native timers, web-call AI judge, gasless (Cruise)

## Note

Testnet only — all amounts are test tokens with no real value. This entire project was designed, coded, and deployed from an **Android phone** 📱.
