// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Token {
    string public name = "AdiCoin";
    uint public supply = 0;
    address public owner;
    mapping(address => uint) public balances;
    mapping(address => mapping(address => uint)) public allowances;

    constructor() {
        owner = msg.sender;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowances[msg.sender][_spender] = _value;
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= allowances[_from][msg.sender], "Allowance too low");
        require(_value <= balances[_from], "Balance too low");
        balances[_from] -= _value;
        balances[_to] += _value;
        allowances[_from][msg.sender] -= _value;
        return true;
    }

    function mintTo(address to, uint amount) public {
        require(msg.sender == owner, "Only owner can mint");
        balances[to] += amount;
        supply += amount;
    }

    function transfer(address to, uint amount) public {
        uint balance = balances[msg.sender];
        require(balance >= amount, "You dont have enough balance");
        balances[msg.sender] -= amount;
        balances[to] += amount;
    }

    function burn(uint amount) public {
        uint balance = balances[msg.sender];
        require(balance >= amount, "You dont have enough balance");
        balances[msg.sender] -= amount;
        supply -= amount;
    }
}
 
