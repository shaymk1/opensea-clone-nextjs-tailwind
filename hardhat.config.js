//require("@nomiclabs/hardhat-waffle");
require("@nomicfoundation/hardhat-chai-matchers");
require("@nomiclabs/hardhat-ethers");

require("dotenv").config();

//const fs =require("fs");
//const PRIVATE_KEY = fs.readFileSync(".secret").toString();
//const projectId = "536442d6e6114afebcc5cf916ee10607";

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
	networks: {
		hardhat: {
			chainId: 1337,
		},

		mumbai: {
			//url: `https://polygon-mumbai.infura.io/v3/${projectId}`,
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
