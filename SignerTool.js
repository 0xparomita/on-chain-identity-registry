const { ethers } = require("ethers");

async function generateIdentitySignature(issuerWallet, userAddress, expiration, chainId, contractAddress) {
    const domain = {
        name: "IdentityRegistry",
        version: "1",
        chainId: chainId,
        verifyingContract: contractAddress
    };

    const types = {
        VerifyIdentity: [
            { name: "user", type: "address" },
            { name: "expiration", type: "uint256" }
        ]
    };

    const value = {
        user: userAddress,
        expiration: expiration
    };

    const signature = await issuerWallet.signTypedData(domain, types, value);
    return signature;
}

module.exports = { generateIdentitySignature };
