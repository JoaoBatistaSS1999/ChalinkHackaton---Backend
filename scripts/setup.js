const dotenv = require("dotenv");
dotenv.config();
const { ethers } = require("hardhat");
const provider = new ethers.providers.JsonRpcProvider(
  "https://rpc.ankr.com/polygon_mumbai"
);
const employeeABI =
  require("../artifacts/contracts/Employees.sol/Employees.json").abi;
const address = "0xe1931EcA376a9a545fd68BA30d5C3497E303309A";
const signer = new ethers.Wallet(process.env.PRIVATE_KEY, provider);
const employeeContract = new ethers.Contract(address, employeeABI, signer);

const wallet1 = new ethers.Wallet.createRandom();
const wallet2 = new ethers.Wallet.createRandom();
const wallet3 = new ethers.Wallet.createRandom();
const wallet4 = new ethers.Wallet.createRandom();
const wallet5 = new ethers.Wallet.createRandom();

const main = async () => {
  setTimeout(async () => {
    await employeeContract.addEmployee(
      "John Doe",
      1,
      27111987,
      50000,
      wallet1.address
    );
  }, 3000);

  setTimeout(async () => {
    await employeeContract.addEmployee(
      "Joao Doe",
      1,
      10091983,
      50000,
      wallet2.address
    );
  }, 7000);

  setTimeout(async () => {
    await employeeContract.addEmployee(
      "Jay Doe",
      1,
      25061994,
      50000,
      wallet3.address
    );
  }, 14000);

  setTimeout(async () => {
    await employeeContract.addEmployee(
      "Toby Doe",
      1,
      31101990,
      50000,
      wallet4.address
    );
  }, 20000);

  setTimeout(async () => {
    await employeeContract.addEmployee(
      "Lucas Doe",
      1,
      31101990,
      50000,
      wallet5.address
    );
  }, 25000);
};

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
