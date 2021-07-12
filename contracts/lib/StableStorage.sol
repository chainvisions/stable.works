pragma solidity 0.8.6;

contract StableGovernanceStorage {
    mapping (address => address) internal _delegates;

    /// @notice A checkpoint for marking number of votes from a given block
    struct Checkpoint {
        uint32 fromBlock;
        uint votes;
    }

    /// @notice A record of votes checkpoints for each account, by index
    mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;

    /// @notice The number of checkpoints for each account
    mapping (address => uint32) public numCheckpoints;

    /// @notice The EIP-712 typehash for the contract's domain
    bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint chainId,address verifyingContract)");

    /// @notice The EIP-712 typehash for the delegation struct used by the contract
    bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint nonce,uint expiry)");

    /// @notice A record of states for signing / validating signatures
    mapping (address => uint) public nonces;

      /// @notice An event thats emitted when an account changes its delegate
    event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);

    /// @notice An event thats emitted when a delegate account's vote balance changes
    event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
}

contract StableStorage is StableGovernanceStorage {

    /// @notice Stable Stabilizer
    bytes32 public constant STABILIZER_ROLE = keccak256("STABILIZER_ROLE");
    
    /// @notice Stable rebaser for emergency rebases.
    bytes32 public constant REBASER_ROLE = keccak256("REBASER_ROLE");

    uint internal constant _INTERNAL_DECIMALS = 10**24;

    uint internal constant BASE = 10**18;

    /// @notice Scaling factor for Stable's supply.
    uint public stableScalingFactor;

    mapping(address => uint256) internal _balances;

    mapping(address => mapping (address => uint256)) _allowedStables;
    
    /// @notice Initial supply for rebase logic.
    uint public initialSupply;
}