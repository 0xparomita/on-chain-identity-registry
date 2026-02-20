# On-Chain Identity Registry

A high-quality, expert-level implementation of a decentralized identity (DID) verification system. This repository provides the smart contract logic to manage "Verified" status for users in DeFi protocols, NFT whitelists, or DAO governance.

## Features
* **EIP-712 Compliance**: Uses structured data signing for secure, off-chain signature generation.
* **Gas-Less Verification**: Users can receive a signature off-chain and submit it to the registry, or an issuer can submit it on their behalf.
* **Role-Based Access**: Distinguishes between the `Admin` (who manages issuers) and `Issuers` (who verify users).
* **Expiration Logic**: Includes timestamps to ensure identity verifications must be renewed periodically.

## Technical Architecture


1. **Issuer** validates user identity off-chain.
2. **Issuer** signs a message containing the user's address and an expiration date.
3. **User** or **Issuer** submits the signature to `IdentityRegistry.sol`.
4. **Smart Contract** recovers the signer address to verify authenticity and updates the registry.

## License
MIT
