// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

/**
 * @title IdentityRegistry
 * @dev Manages on-chain verification status using EIP-712 signatures.
 */
contract IdentityRegistry is EIP712, AccessControl {
    using ECDSA for bytes32;

    bytes32 public constant ISSUER_ROLE = keccak256("ISSUER_ROLE");
    bytes32 public constant IDENTITY_TYPEHASH = keccak256("VerifyIdentity(address user,uint256 expiration)");

    mapping(address => uint256) public userExpirations;

    event IdentityVerified(address indexed user, uint256 expiration);
    event IdentityRevoked(address indexed user);

    constructor(address admin) EIP712("IdentityRegistry", "1") {
        _grantRole(DEFAULT_ADMIN_ROLE, admin);
    }

    /**
     * @dev Verify a user using a signature from an authorized issuer.
     */
    function verifyIdentity(
        address user,
        uint256 expiration,
        bytes calldata signature
    ) external {
        require(expiration > block.timestamp, "Signature expired");

        bytes32 structHash = keccak256(abi.encode(IDENTITY_TYPEHASH, user, expiration));
        bytes32 hash = _hashTypedDataV4(structHash);
        address signer = hash.recover(signature);

        require(hasRole(ISSUER_ROLE, signer), "Invalid issuer signature");

        userExpirations[user] = expiration;
        emit IdentityVerified(user, expiration);
    }

    function isVerified(address user) public view returns (bool) {
        return userExpirations[user] > block.timestamp;
    }

    function revokeIdentity(address user) external onlyRole(ISSUER_ROLE) {
        userExpirations[user] = 0;
        emit IdentityRevoked(user);
    }
}
