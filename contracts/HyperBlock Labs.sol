// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract HyperBlockLabs {
    string public projectName = "HyperBlock Labs";
    uint256 public totalUsers;
    mapping(address => bool) public registeredUsers;

    // Event emitted when a user registers
    event UserRegistered(address indexed user);

    // Function 1: Register a user
    function registerUser() public {
        require(!registeredUsers[msg.sender], "User already registered");
        registeredUsers[msg.sender] = true;
        totalUsers += 1;
        emit UserRegistered(msg.sender);
    }

    // Function 2: Check if a user is registered
    function isUserRegistered(address user) public view returns (bool) {
        return registeredUsers[user];
    }

    // Function 3: Get total registered users
    function getTotalUsers() public view returns (uint256) {
        return totalUsers;
    }
}
