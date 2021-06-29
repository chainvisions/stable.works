// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.7.6;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "./interfaces/IRewardPool.sol";

/// @title Stable Arbitrage Pool
/// @author Chainvisions
/// @notice Pool for performing arbitrage using the STBL treasury.

contract ArbitragePool is AccessControl {
    using SafeERC20 for IERC20;
    using SafeMath for uint;

    /// @notice STBL token.
    address public stbl;

    /// @notice Percentage of funds to award to arbitrageurs.
    uint public arberNumerator;

    /// @notice Precision for percentage calculations.
    uint public constant PRECISION = 10000;

    /// @notice Pool to distribute rewards for LPs to.
    address public lpRewards;

    /// @notice Circuit breaker.
    bool public paused;

    event ArbitragePerformed(address indexed arbitrageur, uint arbitrageReward, uint lpReward);

    modifier onlyWhenNotPaused {
        require(!paused, "ArbitragePool: Arbitrage pool paused");
        _;
    }

    /// @dev Performs arbitrage on STBL's pools.
    function performArbitrage() external onlyWhenNotPaused {
        require(msg.sender == tx.origin, "ArbitragePool: Only EOAs may perform arbitrage");

        uint bal = IERC20(stbl).balanceOf(address(this));
        uint arbitrageIncentive = bal.mul(arberNumerator).div(PRECISION);
        uint lpIncentive = bal.sub(arbitrageIncentive);

        IERC20(stbl).safeTransfer(msg.sender, arbitrageIncentive);
        IERC20(stbl).safeTransfer(lpRewards, lpIncentive);

        IRewardPool(lpRewards).notifyRewardAmount(lpIncentive);

        emit ArbitragePerformed(msg.sender, arbitrageIncentive, lpIncentive);
    }

    /// @dev Sets the numerator for arbitrage rewards.
    /// @param _arberNumerator Numerator for calculating percentages.
    function setArberNumerator(uint _arberNumerator) external {
        arberNumerator = _arberNumerator;
    }

    /// @dev Sets the LP rewards contract.
    /// @param _lpRewards Rewards contract.
    function setLpRewards(address _lpRewards) external {
        lpRewards = _lpRewards;
    }

    /// @dev Pauses/Unpauses the arbitrage contract.
    /// @param _paused To pause or unpause.
    function setPaused(bool _paused) external {
        paused = _paused;
    }

}