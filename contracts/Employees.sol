// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Payroll.sol";

contract Employees is Ownable {

    Payroll public PayrollContract;
    uint256 public employeeCounter;

    uint256 monthSize = 4;
    uint256 public monthCurrentDay = 1;

    string public companyName;
    mapping(address => bool) public isAdmin;

    struct Employee {
        string name;
        uint256 moneyPerYear;
        uint256 moneyPerMonth;
        address walletAddress;
        uint256 nextMonthPayment;
        bool active;
        uint id;
    }

    mapping(uint256 => Employee) public employees;

    event EmpoloyeeCreated(
        string indexed _name,
        uint256 _salary,
        address indexed _wallet
    );

    event EmpoloyeeDeleted(
        string indexed _name,
        uint256 _salary,
        address indexed _wallet
    );

    event EmployeePaid(string _name, address _wallet, uint256 _amount);

    event AdminAdded(address _assignee, address _newAdmin);

    event AdminRemoved (address _demoter, address _employee);

    modifier onlyAdmin {
        require(isAdmin[msg.sender], "Only Admins can call this function");
        _;
    }

    constructor(address _payroll, string memory _companyName) {
        PayrollContract = Payroll(_payroll);
        companyName = _companyName;
        isAdmin[msg.sender] = true;
    }



    // Create New Employee
    function addEmployee(
        string memory _name,
        uint256 _salary,
        address _wallet
    ) public onlyOwner {
        Employee storage employee = employees[employeeCounter];
        employee.name = _name;
        employee.moneyPerYear = _salary;
        employee.moneyPerMonth = _salary / 12;
        employee.walletAddress = _wallet;
        // this is assuming an employee starts working the day they get in
        employee.nextMonthPayment = monthCurrentDay == 1 ? employee.moneyPerMonth : (monthSize - monthCurrentDay + 1) * employee.moneyPerMonth / monthSize;
        employee.id = employeeCounter;
        employee.active = true;

        unchecked {
            employeeCounter++;
        }

        emit EmpoloyeeCreated(_name, _salary, _wallet);
    }

    // Delete Employee
        function deleteEmployee(uint256 _employeeId) public onlyOwner {
        require(_employeeId <= employeeCounter, "Employee ID does not exist");

        Employee storage employee = employees[_employeeId];
        employee.active = false;

        emit EmpoloyeeDeleted(
            employee.name,
            employee.moneyPerYear,
            employee.walletAddress
        );

        // Liquidate
        uint256 salaryPerDay = employee.moneyPerYear / 12 * monthSize;  // monthSize instead of 30 because we are using shorter cicles for test reasons
        uint256 pendingPay = monthCurrentDay - 1 * salaryPerDay;
        PayrollContract.mint(employee.walletAddress, pendingPay);  // The same logic as adding an employee, deleting considers that you gonna get fired in the morning, so you wont work that day
    }

    // Get all active employees
    function getAllActiveEmployees() public view returns (Employee[] memory) {
        Employee[] memory activeEmployeeArray = new Employee[](employeeCounter);

        for (uint256 i; i < employeeCounter; i++) {
            Employee memory employeeLoop = getEmployeeById(i);
            if (employeeLoop.active) {
                activeEmployeeArray[i] = employeeLoop;
            }
        }

        return activeEmployeeArray;
    }

    // Get all inactive employees
    function getInactiveEmployees() public view returns (Employee[] memory) {

        Employee[] memory inactiveEmployeeArray;
        uint256 localCounter;

        for (uint256 i; i < employeeCounter; i++) {
            if (!getEmployeeById(i).active) {
                inactiveEmployeeArray[localCounter] = (getEmployeeById(i));

                localCounter++;
            }
        }

        return inactiveEmployeeArray;
    }



    // Payments
    function payEmployees() public {
        for (uint i; i < employeeCounter; i++) {

            if (employees[i].active) {  // checking first who is active

                PayrollContract.mint(
                        employees[i].walletAddress,
                        employees[i].nextMonthPayment
                );

                emit EmployeePaid(employees[i].name,employees[i].walletAddress, employees[i].nextMonthPayment); // emits the event before updating nextMonthPayment;
                employees[i].nextMonthPayment = employees[i].moneyPerMonth;
            }
        }
    }

    // Simulates a day of work
    function dayOfWork() public onlyAdmin {

        if (monthCurrentDay == monthSize) {
            payEmployees();
            monthCurrentDay = 1;
        } else {
            monthCurrentDay ++;
        }
    }

    // Getter Functions
    function getEmployeeById(uint256 _employeeId)
        public
        view
        returns (Employee memory)
    {
        Employee storage employee = employees[_employeeId];
        return employee;
    }

    // Setter functions
    function setAdmin(address _address) public onlyOwner {
        require(!isAdmin[_address], "This employee is already an admin!");
        isAdmin[_address] = true;
        emit AdminAdded(msg.sender, _address);
    }

    function removeAdmin(address _address) public onlyOwner {
        require(isAdmin[_address], "This employee is not an admin!");
        isAdmin[_address] = false;
        emit AdminRemoved(msg.sender, _address);
    }

}
