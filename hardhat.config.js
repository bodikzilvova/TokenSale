require("@nomiclabs/hardhat-waffle");
require("dotenv").config();

require("@nomiclabs/hardhat-ethers");

require("@nomiclabs/hardhat-etherscan");

module.exports = {
  solidity: "0.8.20",
  networks: {
    sepolia: {
      url: process.env.ALCHEMY_RPC_URL,
      accounts: [process.env.TESTNET_PRIVATE_KEY],
    },
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_PRIVATE_KEY,
  },
};
