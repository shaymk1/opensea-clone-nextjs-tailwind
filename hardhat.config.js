//require("@nomiclabs/hardhat-waffle");
require("@nomicfoundation/hardhat-chai-matchers");
require("@nomiclabs/hardhat-ethers");

require("dotenv").config();



/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
	networks: {
		hardhat: {
			chainId: 1337,
		},

		mumbai: {
			
			url: process.env.MUMBAI_RPC_URL,
			accounts: [process.env.PRIVATE_KEY],
		},

		mainnet: {
			url: process.env.MAINNET_RPC_URL,
			accounts: [process.env.PRIVATE_KEY],
		},
	},
	solidity: "0.8.9",
};
