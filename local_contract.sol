assignments





-----------------test contract--------------------------------
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {MyToken} from "../src/Contract.sol";

contract MyTokenTest is Test {
    MyToken token;
    address owner = address(this);
    address alice = address(0x1);
    address bob   = address(0x2);

    function setUp() public {
        token = new MyToken(1000 ether);
    }

    function testInitialSupply() public {
        assertEq(token.balanceOf(owner), token.totalSupply());
    }

    function testTransfer() public {
        bool success = token.transfer(alice, 100 ether);
        require(success, "Transfer failed");
        assertEq(token.balanceOf(alice), 100 ether);
    }

    function testRevert_When_InsufficientBalance() public {
        vm.prank(bob);
        vm.expectRevert("ERC20: transfer amount exceeds balance");
        bool success = token.transfer(alice, 1 ether);
        require(success, "Transfer failed");

    }

    function testMultipleTransfers() public {
        bool success1 = token.transfer(alice, 200 ether);
        require(success1, "Transfer failed");

        vm.prank(alice);
        bool success2 = token.transfer(bob, 50 ether);
        require(success2, "Transfer failed");

        assertEq(token.balanceOf(alice), 150 ether);
        assertEq(token.balanceOf(bob), 50 ether);
    }
}


--------------contract------------------------
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

/// @title MyToken - A simple ERC20 token
contract MyToken is ERC20 {
    constructor(uint256 initialSupply) ERC20("MyToken", "MTK") {
        _mint(msg.sender, initialSupply);
    }
}
---------------------------------------
