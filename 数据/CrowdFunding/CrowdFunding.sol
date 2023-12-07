// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0; //版本指令
contract crowdfuding {
    address private immutable benificiary; //受益人地址
    uint private immutable fundingGoal;    //筹资目标
    uint public fundingAmount;             //当前金额
    mapping(address => uint) public funders;//捐款人的金额记录
    mapping(address => bool) private funderInserted;//是否捐过款
    address[] public fundersKey;           //存储捐款人的地址
    bool public AVAILABLED = true;

    //? 参数传递时，要加memory的是哪些数据类型
    constructor(address _benificiary, uint _fundingGoal) {
        benificiary = _benificiary;
        fundingGoal = _fundingGoal;
    }

    function contribute() external payable{
        //? payable 怎么用
        //? 转账逻辑怎么实现
        // payable 并不负责交易的实现，只负责实现交易金额数据mas.value的接收，具体的交易由以太坊来实现
        /*
            当用户调用 contribute 函数时，他们可以选择发送一定数量的以太币。
            这个以太币的数量是通过交易的 value 字段指定的。
            交易被发送到网络后，以太坊会自动处理以太币的转移，将其从发送者的账户转移到智能合约的账户。
            同时，智能合约的 contribute 函数被触发，其中的 msg.value 将包含这笔交易附带的以太币数量。
        */
        //涉及交易，必须要有回调/异常函数（require，assert，error）
        require(AVAILABLED, "The constract is closed!");
        funders[msg.sender] += msg.value;
        funderInserted[msg.sender] = true;
        fundersKey.push(msg.sender);
        fundingAmount += msg.value;
    }

    function close() external payable returns(bool){
        if(fundingAmount < fundingGoal){
            return false;
        }
        // ? payable(),transfer()函数怎么进行金额转移
        //payable()并不是函数，而是类型转换
        //它将一个地址转换为 payable 地址，表示该地址可以接收以太币。
        //transfer()函数 -> recipient.transfer(amount); // 使用 transfer 函数发送以太币
        //调用transfer函数需要提供可接受eth的地址，括号内表示转账金额
        //调用transfer函数实现的交易实质上修改了合约的状态
        //*注：transfer 函数会自动处理转移失败的情况，如果转移失败（例如，接收地址不存在或是合约），
        //它会抛出异常，因此您可以在智能合约中安全使用它。
        uint _amount = fundingAmount;
        fundingAmount = 0;
        AVAILABLED = false;
        payable(benificiary).transfer(_amount);
        return true;
    }
    
    function fundersLenght() public view returns(uint256){
        return fundersKey.length;
    }
}