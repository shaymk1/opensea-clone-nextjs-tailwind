require("@nomicfoundation/hardhat-toolbox");
require("@nomiclabs/hardhat-waffle");

const fs =require("fs");
const privateKey = fs.readFileSync(".secret").toString();
const projectId = "536442d6e6114afebcc5cf916ee10607";
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
	networks: {
		hardhat: {
			chainId: 1337,
		},

		mumbai: {
			url: `https://polygon-mumbai.infura.io/v3/${projectId}`,
			accounts: [privateKey],
		},

		mainnet: {
			url: `https://polygon-mainnet.infura.io/v3/${projectId}`,
			accounts: [privateKey],
		},
	},
	solidity: "0.8.9",
};
