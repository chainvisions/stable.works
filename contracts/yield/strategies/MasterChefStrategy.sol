pragma solidity 0.7.6;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "../../interfaces/IYieldStrategy.sol";
import "../../interfaces/yield-farming/IMasterChef.sol";

/// @title MasterChef Strategy
/// @author Chainvisions
/// @notice Boilerplate strategy for STBL reward pools that
/// interacts with a MasterChef contract.

contract MasterChefStrategy is IYieldStrategy {
    using SafeERC20 for IERC20;

    address public override underlying;
    address public override yieldToken;

    IMasterChef public rewardPool;
    uint public poolId;

    constructor(address _underlying, address _yield, IMasterChef _pool, uint _pid) {
        underlying = _underlying;
        yieldToken = _yield;
        rewardPool = _pool;
        // Sanity check to ensure the pool is correct.
        (address tkn,,,) = rewardPool.poolInfo(_pid);
        require(tkn == underlying, "MasterChefStrategy: Pool token is not underlying");
        poolId = _pid;
    }

    /**
    * @dev Invests `_amount` into the MasterChef contract.
     */
    function deposit(uint _amount) external override {
        IERC20(underlying).safeApprove(address(rewardPool), 0);
        IERC20(underlying).safeApprove(address(rewardPool), _amount);
        rewardPool.deposit(poolId, _amount);
    }

    /**
    * @dev Withdraws `_amount` from the MasterChef.
     */
    function withdraw(uint _amount) external override {
        rewardPool.withdraw(poolId, _amount);
    }

    /**
    * @dev Collects yields.
     */
    function collectYield() external override {
        rewardPool.deposit(poolId, 0);
    }

    /**
    * @dev Performs an emergency exit from the pool.
     */
    function emergencyExit() external override {
        rewardPool.emergencyWithdraw(poolId);
        IERC20(underlying).safeApprove(address(rewardPool), 0);
    }
}