pragma solidity 0.7.6;

interface IRewardPool {
    function exit() external;
    function getReward() external;
    function stake(uint) external;
    function withdraw(uint) external;
    function notifyRewardAmount(uint) external;
    function balanceOf(address) external view returns (uint256);
    function earned(address) external view returns (uint256);
    function getRewardForDuration() external view returns (uint256);
    function lastTimeRewardApplicable() external view returns (uint256);
    function rewardPerToken() external view returns (uint256);
    function rewardsDistribution() external view returns (address);
    function rewardsToken() external view returns (address);
    function totalSupply() external view returns (uint256);
}