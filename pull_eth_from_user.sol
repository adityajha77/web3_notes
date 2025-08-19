// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Inheritance {
    uint public startTime;       // when contract was deployed
    uint public tenYears;        // time period after which recipient can claim
    uint public lastVisited;     // last time owner "pinged"
    address public owner;        // owner of contract
    address public recipient;    // recipient who can claim after inactivity

    // constructor: runs only once at deployment
    constructor(address payable _recipient) {
        tenYears = 1 hours * 24 * 365 * 10; // approx 10 years
        startTime = block.timestamp;        // deployment time
        lastVisited = block.timestamp;      // initialize last visit
        owner = msg.sender;                 // deployer is the owner
        recipient = _recipient;             // set recipient
    }

    // only owner can call certain functions
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    // only recipient can call certain functions
    modifier onlyRecipient() {
        require(msg.sender == recipient, "Not recipient");
        _;
    }

    // deposit ETH into contract (only owner can deposit)
    function deposit() public payable onlyOwner {
        lastVisited=block.timestamp;
    }

    // owner "pings" to refresh activity
    function ping() public onlyOwner {
        lastVisited = block.timestamp;
    }

    // recipient claims funds if owner inactive for 10 years
    function claim() external onlyRecipient {
        require(
            lastVisited < block.timestamp - tenYears,
            "Owner still active"
        );
        payable(recipient).transfer(address(this).balance);
    }
}
