// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0; //版本指令
contract crowdfuding{
    address public beneficiary; //受益人

    mapping(address => uint) public funders; //捐赠人地址到捐赠金额的映射
}