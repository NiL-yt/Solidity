// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0; //版本指令
contract demo {
    string public test  = "hello world";
    bool public isbool = true;
    function getDemo() public view returns(string memory){
        return test;
    }
}