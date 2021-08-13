// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.6;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/draft-ERC20PermitUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20VotesUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20FlashMintUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract Stable is Initializable, ERC20Upgradeable, AccessControlUpgradeable, ERC20PermitUpgradeable, ERC20VotesUpgradeable, ERC20FlashMintUpgradeable {
    bytes32 public constant STABILIZER_ROLE = keccak256("STABILIZER_ROLE");
    bytes32 public constant REBASER_ROLE = keccak256("REBASER_ROLE");

    function initialize() initializer public {
        __ERC20_init("Stable.Works", "STBL");
        __AccessControl_init();
        __ERC20Permit_init("Stable.Works");
        __ERC20FlashMint_init();

        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(STABILIZER_ROLE, msg.sender);
        _setupRole(REBASER_ROLE, msg.sender);
    }

    function mint(address to, uint256 amount) public onlyRole(STABILIZER_ROLE) {
        _mint(to, amount);
    }

    function _afterTokenTransfer(address from, address to, uint256 amount)
        internal
        override(ERC20Upgradeable, ERC20VotesUpgradeable)
    {
        super._afterTokenTransfer(from, to, amount);
    }

    function _mint(address to, uint256 amount)
        internal
        override(ERC20Upgradeable, ERC20VotesUpgradeable)
    {
        super._mint(to, amount);
    }

    function _burn(address account, uint256 amount)
        internal
        override(ERC20Upgradeable, ERC20VotesUpgradeable)
    {
        super._burn(account, amount);
    }
}