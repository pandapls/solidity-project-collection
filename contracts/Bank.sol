// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.17;

contract Bank {
    address public immutable owner;

    event Deposit(address _ads, uint256 amount);
    event Withdraw(uint256 amount);
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }


    receive() external payable { 
        emit Deposit(msg.sender, msg.value);
    }

    constructor() payable {
        owner = msg.sender;
    }

    function withdraw() external onlyOwner {
        emit Withdraw(address(this).balance);
        payable(msg.sender).transfer(address(this).balance);
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }


}