// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.7.0;

// @0x445791a1C7d62418ea7Ec85C37A59167756E4a17 on Mumbai

contract UserCrud {

    struct UserStruct {
        string userName;
        uint userAge;
        uint index;
    }

    mapping(address => UserStruct) private userStructs;
    address[] private userIndex;

    event LogNewUser   (address indexed userAddress, uint index, string userName, uint userAge);
    event LogUpdateUser(address indexed userAddress, uint index, string userName, uint userAge);

    function isUser(address userAddress)
    public view
    returns(bool isIndeed)
    {
        if(userIndex.length == 0) return false;
        return (userIndex[userStructs[userAddress].index] == userAddress);
    }

    function insertUser(
        address userAddress,
        string memory userName,
        uint    userAge)
    public
    returns(uint index)
    {
        require(!isUser(userAddress));
        userStructs[userAddress].userName = userName;
        userStructs[userAddress].userAge   = userAge;
        uint indexLength = userIndex.length;
        userIndex.push(userAddress);
        userStructs[userAddress].index     = indexLength;
        emit LogNewUser(
            userAddress,
            userStructs[userAddress].index,
            userName,
            userAge);
        return indexLength;
    }

    function getUser(address userAddress)
    public view
    returns(string memory userName, uint userAge, uint index)
    {
        require(isUser(userAddress));
        return(
        userStructs[userAddress].userName,
        userStructs[userAddress].userAge,
        userStructs[userAddress].index);
    }

    function updateUserName(address userAddress, string memory userName)
    public
    returns(bool success)
    {
        require(!isUser(userAddress));
        userStructs[userAddress].userName = userName;
        LogUpdateUser(
            userAddress,
            userStructs[userAddress].index,
            userName,
            userStructs[userAddress].userAge);
        return true;
    }

    function updateUserAge(address userAddress, uint userAge)
    public
    returns(bool success)
    {
        require(isUser(userAddress));
        userStructs[userAddress].userAge = userAge;
        emit LogUpdateUser(
            userAddress,
            userStructs[userAddress].index,
            userStructs[userAddress].userName,
            userAge);
        return true;
    }

    function getUserCount()
    public
    view
    returns(uint count)
    {
        return userIndex.length;
    }

    function getUserAtIndex(uint index)
    public
    view
    returns(address userAddress)
    {
        return userIndex[index];
    }

}

