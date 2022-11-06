const { ethers, hre } = require("hardhat");

async function main() {
  const wallet1 = new ethers.Wallet.createRandom();
  const wallet2 = new ethers.Wallet.createRandom();
  const wallet3 = new ethers.Wallet.createRandom();
  const wallet4 = new ethers.Wallet.createRandom();
  const wallet5 = new ethers.Wallet.createRandom();

  // Deploy Token Contract
  const BenefitsToken = await ethers.getContractFactory("BenefitsToken");
  const token = await BenefitsToken.deploy();
  await token.deployed();
  console.log("BenefitsToken deployed at:", token.address);

  // Deploy Payroll Contract
  const Payroll = await ethers.getContractFactory("EmployeePayroll");
  const payroll = await Payroll.deploy();
  await payroll.deployed();
  console.log("Payroll deployed at:", payroll.address);

  // Deploy Employee Contract
  const Employee = await ethers.getContractFactory("Employees");
  const employees = await Employee.deploy(token.address, payroll.address);
  await employees.deployed();
  console.log("Employees deployed at:", employees.address);

  // Update Contract Address
  setTimeout(async () => {
    await token.updateEmployeeContract(employees.address);
    await payroll.updateEmployeeContractAddress(employees.address);
    await payroll.updateEmployeeContract(employees.address);
  }, 10000);
}
// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
