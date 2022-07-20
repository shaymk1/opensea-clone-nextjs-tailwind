
//require("@nomiclabs/hardhat-waffle");
require("@nomicfoundation/hardhat-chai-matchers");
require("@nomiclabs/hardhat-ethers");

const fs =require("fs");
const PRIVATE_KEY = fs.readFileSync(".secret").toString();
const projectId = "536442d6e6114afebcc5cf916ee10607";
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
	networks: {
		hardhat: {
			chainId: 1337,
		},

		mumbai: {
			url: `https://polygon-mumbai.infura.io/v3/${projectId}`,
			accounts: [`${PRIVATE_KEY}`],
		},

		// mainnet: {
		// 	url: `https://polygon-mainnet.infura.io/v3/${projectId}`,
		// 	accounts: [privateKey],
		// },
	},
	solidity: "0.8.9",
};
