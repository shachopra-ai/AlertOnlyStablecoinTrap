# AlertOnlyStablecoinTrap
Deploying Drosera Trap

# 🏷️ AlertOnlyStablecoinTrap

## 🌟 Description

This Drosera **Alert-Only Trap** monitors the price of a stablecoin (defaulting to USDC/USD on Ethereum Mainnet) against a hardcoded de-peg threshold.

The primary feature of this trap is that its **`shouldRespond()` function always returns `false`**. It is designed purely for **off-chain alerting and observation**, ensuring that no automated, on-chain transactions are ever triggered, making it a safe and essential tool for initial monitoring.

## ⚙️ How It Works

1.  **Data Source:** The `collect()` function queries a Chainlink `IAggregatorV3` price feed.
2.  **Threshold:** The constant `MIN_PRICE` (e.g., $0.98 \times 10^8$) defines the critical de-peg threshold.
3.  **Logic:** The `shouldAlert()` function decodes the price and returns `true` (triggering an off-chain alert) if the price is below `MIN_PRICE`.
4.  **No On-Chain Response:** The `shouldRespond()` function is explicitly set to never trigger an on-chain response, limiting its functionality to alerting only.

## 📐 Configuration

| Parameter | Type | Default Value | Description |
| :--- | :--- | :--- | :--- |
| `PRICE_FEED` | `IAggregatorV3` | `0x8fFfFfd4AfB6115b954Bd326cbe7B4BA576818f6` | **USDC/USD** on Ethereum Mainnet (8 decimals). Change this address to monitor a different stablecoin/asset. |
| `MIN_PRICE` | `int256` | `98000000` | Price threshold, represented with 8 decimals. Equivalent to **$0.98$ USD**. |

## 🛠️ Use Case

This trap is perfect for:
* Initial deployment where you want to **monitor a de-peg event** before activating any automated defense mechanisms.
* **Integrating with an external alerting system** (e.g., Slack, PagerDuty) without needing to involve on-chain transaction costs or risks.
