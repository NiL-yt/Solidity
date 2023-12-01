// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0; //版本指令
contract crowdfuding {

    address public beneficiary; //受益人
    uint public immutable fundingGoal;//目标金额
    uint public fundingAmount;//已筹金额
    address[] public funder;//捐赠人名单
    uint fundersKey;//资助者人数
    mapping(address => uint) public funders; //捐赠人地址到捐赠金额的映射

    event isFunding(uint _id, uint _amount, address _funder);

    constructor(address _beneficiary, uint _fundingGoal) {
        beneficiary = _beneficiary; //初始化受益人
        fundingGoal = _fundingGoal; //初始化目标金额
    }

    function fund(uint _amount) public payable{ // ? require
        require(msg.sender.balance > _amount, "You should have so much money!");
        funders[msg.sender] = _amount;
        fundingAmount += _amount;
        //* msg.value 是一个特殊的全局变量，用于表示当前合约接收到的以太币（ETH）数量。
        funder.push(msg.sender);
        emit isFunding(funder.length, funders[msg.sender], msg.sender);
    }

    function getFundersList() public view returns (address[] memory){
        return funder;
    }

    function getFundersKey() public view returns (uint){
        return funder.length;
    }
}