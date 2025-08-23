
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

contract AditCoin is ERC20, Ownable {
    constructor(uint256 initialSupply) ERC20("Aditya", "ADIT") Ownable(msg.sender) {
        _mint(msg.sender, initialSupply * 10 ** decimals());
    }

    function mint(address _to, uint256 amount) public onlyOwner {
        _mint(_to, amount);
    }
}
---------------------------
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

contract DAditCoin is ERC20, Ownable {
    constructor(uint256 initialSupply) ERC20("DAditya", "DADIT") Ownable(msg.sender) {
        _mint(msg.sender, initialSupply * 10 ** decimals());
    }

    function mint(address _to, uint256 amount) public onlyOwner {
        _mint(_to, amount);
    }

    function burn(address _from, uint256 amount) public onlyOwner {
        _burn(_from, amount);
    }
}
-----------------------
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

contract BridgeETH is Ownable {
    address public tokenAddress;

    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);
    event BurnedOnOppositeChain(address indexed user, uint256 amount);

    mapping(address => uint256) public pendingBalance;

    constructor(address _tokenAddress) Ownable(msg.sender) {
        tokenAddress = _tokenAddress;
    }

    function deposit(IERC20 _tokenAddress, uint256 _amount) public {
        require(address(_tokenAddress) == tokenAddress, "Invalid token");
        require(_tokenAddress.allowance(msg.sender, address(this)) >= _amount, "Allowance too low");

        bool success = _tokenAddress.transferFrom(msg.sender, address(this), _amount);
        require(success, "Transfer failed");

        emit Deposit(msg.sender, _amount);
    }

    function withdraw(IERC20 _tokenAddress, uint256 _amount) public {
        require(pendingBalance[msg.sender] >= _amount, "Not enough pending balance");

        pendingBalance[msg.sender] -= _amount;
        bool success = _tokenAddress.transfer(msg.sender, _amount);
        require(success, "Withdraw transfer failed");

        emit Withdraw(msg.sender, _amount);
    }

    function burnedOnOppositeChain(address user, uint256 _amount) public onlyOwner {
        pendingBalance[user] += _amount;
        emit BurnedOnOppositeChain(user, _amount);
    }
}
-----------------------------------------
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
//cci used here interface means
interface IBUSDT {
    function mint(address _to, uint256 _amount) external;
    function burn(address _from, uint256 _amount) external;
}

contract BridgeBase is Ownable { 
    address public tokenAddress;

    event Burn(address indexed user, uint256 amount);
    event Mint(address indexed user, uint256 amount);
    event DepositConfirmed(address indexed user, uint256 amount);

    mapping(address => uint256) public pendingBalance;

    constructor(address _tokenAddress) Ownable(msg.sender) {
        tokenAddress = _tokenAddress;
    }

    function burn(IBUSDT _tokenAddress, uint256 _amount) public {
        require(address(_tokenAddress) == tokenAddress, "Invalid token");
        _tokenAddress.burn(msg.sender, _amount);
        emit Burn(msg.sender, _amount);
    }

    function withdraw(IBUSDT _tokenAddress, uint256 _amount) public {
        require(pendingBalance[msg.sender] >= _amount, "Not enough pending balance");

        pendingBalance[msg.sender] -= _amount;
        _tokenAddress.mint(msg.sender, _amount);

        emit Mint(msg.sender, _amount);
    }

    function depositHappenOtherSide(address user, uint256 _amount) public onlyOwner {
        pendingBalance[user] += _amount;
        emit DepositConfirmed(user, _amount);
    }
}
