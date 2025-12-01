// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Trap} from "lib/drosera-contracts/src/Trap.sol";

interface IAggregatorV3 {
    function latestRoundData()
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        );
}

/**
 * @title AlertOnlyStablecoinTrap
 * @notice Reads a Chainlink price feed (8 decimals) and returns an off-chain alert
 *         when price < MIN_PRICE. shouldRespond() is always false so no on-chain txs.
 */
contract AlertOnlyStablecoinTrap is Trap {
    /// Chainlink USDC/USD mainnet feed (8 decimals)
    IAggregatorV3 public constant PRICE_FEED =
        IAggregatorV3(0x8fFfFfd4AfB6115b954Bd326cbe7B4BA576818f6);

    /// e.g. 0.98 * 1e8
    int256 public constant MIN_PRICE = 98000000;

    /// collect(): return latest price encoded as int256
    function collect() external view override returns (bytes memory) {
        (, int256 price,,,) = PRICE_FEED.latestRoundData();
        return abi.encode(price);
    }

    /// shouldAlert(): off-chain alert decision; can be true when price < MIN_PRICE
    function shouldAlert(
        bytes[] calldata data
    ) external pure override returns (bool, bytes memory) {
        int256 price = abi.decode(data[0], (int256));

        if (price <= 0) {
            // invalid data => no alert
            return (false, abi.encode("invalid price"));
        }

        if (price < MIN_PRICE) {
            return (true, abi.encode("ALERT: stablecoin below threshold"));
        } else {
            return (false, abi.encode("OK: stablecoin within threshold"));
        }
    }

    /// shouldRespond(): intentionally NEVER triggers on-chain responses
    /// Always returns false so Drosera will not send any on-chain txs for responses.
    function shouldRespond(
        bytes[] calldata
    ) external pure override returns (bool, bytes memory) {
        return (false, abi.encode("no on-chain response"));
    }
}
