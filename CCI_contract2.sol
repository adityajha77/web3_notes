// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IStorage {
function getNum() external view returns(uint);
function add() external;
}
contract Contract2{
    constructor(){
    }
    
    function proxyAdd() public {
        IStorage(0xcAfF25FD2D2B5824930bA1d885901f1a58cC2A24).add();
    }
    function publicGet() public view returns(uint){
        uint value= IStorage(0xcAfF25FD2D2B5824930bA1d885901f1a58cC2A24).getNum();
        return value;
    }
}

-------------------------------------------------------------
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Storage{
uint public num;
constructor(uint _num){
    num=_num;
}
function getNum() public view returns(uint){
    return num;
}
function add() public {
    num=num+1;
}
}
-------------------------------------------
//payables
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Money{
    uint public totalMoney;

    function deposit() public payable {
        totalMoney += msg.value;
    }
    function withdraw(address  payable ad)public {
        payable(ad).transfer(totalMoney);
        totalMoney=0;
    }
}
//for withdraw and deposit money to other and its a good way to interact .
