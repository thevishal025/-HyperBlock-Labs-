Event emitted when a user registers
    event UserRegistered(address indexed user);

    Function 2: Check if a user is registered
    function isUserRegistered(address user) public view returns (bool) {
        return registeredUsers[user];
    }

    // Function 3: Get total registered users
    function getTotalUsers() public view returns (uint256) {
        return totalUsers;
    }
}
// 
update
// 
