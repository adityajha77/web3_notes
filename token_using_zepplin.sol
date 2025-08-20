// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20; // OZ v5 requires >=0.8.20

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AditCoin is ERC20, Ownable {
    constructor() ERC20("AditCoin", "ADC") Ownable(msg.sender) {
        _mint(msg.sender, 100000000 * 10 ** decimals());
    }

    function mintTo(address account, uint256 amount) public onlyOwner {
        _mint(account, amount);
    }
}
