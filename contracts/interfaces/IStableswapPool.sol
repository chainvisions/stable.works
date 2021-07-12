pragma solidity ^0.8.0;

interface IStableswapPool {
    function originSwap(address, address, uint, uint, uint) external returns (uint);
    function viewOriginSwap(address, address, uint) external view returns (uint);
}