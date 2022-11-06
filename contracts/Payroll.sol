// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Employees.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Payroll is ERC20, Ownable {
    Employees public employeeContract;
    address employeeContractAddress;

    mapping(address => bool) public isAdmin;
    Employee[] public employeeArray;

    struct Employee {
        string name;
        uint256 salary;
        address walletAddress;
        uint256 daysToNextPay;
        uint id;
    }

    modifier onlyEmployeeContract() {
        require(msg.sender == employeeContractAddress);
        _;
    }

    constructor() ERC20("EmployeeUSD", "EMPUSD") {

    }

    function mint(address _to, uint256 _amount) public onlyEmployeeContract { // Safe enought?
        _mint(_to, _amount);
    }

     function setEmployeeContractAddress(address _employeeContractAddress) public onlyOwner {
        employeeContractAddress = _employeeContractAddress;
    }
}
