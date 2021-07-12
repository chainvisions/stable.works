pragma solidity ^0.8.0;

interface IYieldStrategy {
    function deposit(uint) external;
    function withdraw(uint) external;
    function collectYield() external;
    function emergencyExit() external;

    function underlying() external view returns (address);
    function yieldToken() external view returns (address);
}