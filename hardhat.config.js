const dotenv = require("dotenv");
dotenv.config();
require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.17",
  // networks: {
  //   mumbai: {
  //     url: "https://rpc.ankr.com/polygon_mumbai",
  //     accounts: [process.env.PRIVATE_KEY],
  //   },
  // },
  // etherscan: {
  //   apiKey: process.env.MUMBAI_API,
  // },
};
