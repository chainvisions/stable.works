pragma solidity 0.7.6;

interface IMasterChef {
    function deposit(uint, uint) external;
    function withdraw(uint, uint) external;
    function emergencyWithdraw(uint) external;
    function userInfo(uint, address) external view returns (uint, uint);
    function poolInfo(uint) external view returns (address, uint, uint, uint);
}