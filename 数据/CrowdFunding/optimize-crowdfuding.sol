// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0; //版本指令
contract optmizeCrowFunding{
    // 创建受益人筹资状态
    enum Status{
        UnStarted,
        UnderWay,
        Ended
    }

    //创建受益人结构体
    struct Beneficiary{
        uint fundingGoal;    // 目标金额
        uint funded;         // 已筹资金额
        Status status;       // 筹资状态 
    }

    //创建捐款人结构体
    struct Funder{
        //? 结构体内可以包含哪些数据类型
        /*
            1.基本数据类型：
            uint：无符号整数类型，如 uint256。
            int：有符号整数类型，如 int32。
            bool：布尔类型，只能是 true 或 false。
            address：以太坊地址类型，表示以太坊账户地址。
            bytes：字节类型，用于处理二进制数据。
            string：字符串类型，用于处理文本数据。
            2.用户定义的结构体：您可以在结构体内包含其他用户自定义的结构体类型，从而创建复杂的数据结构
            3.枚举类型：结构体可以包含枚举类型，枚举类型用于定义一组有限的离散值。
            4.数组和固定大小数组：您可以在结构体内包含动态数组、固定大小数组或动态字节数组。
            5.映射（mapping）：结构体可以包含映射类型，允许将键值对存储在结构体中。
            6.其他结构体引用：结构体可以包含对其他结构体的引用，从而创建嵌套结构。
        */

        //msg.value 是特定于当前函数调用的，而不是全局的。不同函数调用之间的 msg.value 值是相互独立的。
        uint amount;
        address someOne;
    }

    //创建受益人和捐款人的映射
    mapping(address => Beneficiary) bf;
    mapping(address => Funder) fd;





    // 受益人列表
    Beneficiary[] public bflist;
    // 捐款人列表
    Funder[] public fdlist;




    //定义事件
    event newbf(address _beneficiary, uint _fundingGoal, uint _funded, Status _status);
    event newfd(address _funder, uint _amount, address _someOne);
    //记录收益人筹资状态
    event changedStatus(uint _funded, Status _status);
    //? event可以包含哪些参数 -> 不可以包含mapping




    //创建受益人生成函数
    function createNewBF(uint _fundingGoal) external {
        bf[msg.sender] = Beneficiary(_fundingGoal, 0, Status(0));
        bflist.push(bf[msg.sender]);
        emit newbf(msg.sender, _fundingGoal, 0, Status(0));
    }

    //创建捐款并生成捐款人函数
    function contributeAndCreateNewFD(address _someOne) external payable {
        //结构体内的mapping不能直接赋值
        /*
            *要给结构体内的 mapping 赋值，您需要按照以下步骤进行操作：
            *创建结构体实例：首先，您需要创建一个包含所需数据的结构体实例。
                这个结构体实例将用于表示要存储在 mapping 中的数据。如果 mapping 位于合约中，您可以创建一个新的结构体实例。
            *访问 mapping：使用结构体实例来访问 mapping。结构体实例的属性可以包含 mapping 类型的字段，
                您可以通过该属性来访问 mapping。
            *赋值 mapping：在访问 mapping 后，您可以为其中的键赋值。使用键访问 mapping 中的具体位置，并将所需的值分配给它。
        */
        require(bflist.length != 0, "now there don't have a beneficiary");

        fd[msg.sender] = Funder(msg.value, _someOne);

        fdlist.push(fd[msg.sender]);

        emit newfd(msg.sender, msg.value, _someOne);
        
        bf[_someOne].funded = msg.value;
    }

    
}