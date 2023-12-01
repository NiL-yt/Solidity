// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0; //版本指令
contract TodoList {
    //自定义数据类型enum                                                 // ?(技巧) -> 自定义数据类型 => 使用enum(枚举) √
    enum Status {
        unCompleted,
        inProgress,                                                     
        Completed,
        Cancelled
    }
                            //mapping的使用 √
                            /*
                                mapping：
                                1.键（Keys）的存储：mapping 中的键不是直接存储的。
                                    相反，它们通过一个哈希函数处理以确定值的存储位置。
                                    这意味着您无法遍历或获取mapping中所有的键，因为它们本身并不存储在mapping中。
                                2.动态大小：mapping 是动态大小的，意味着它可以存储无限数量的键值对，只要有足够的gas来处理交易。
                                3.不支持遍历：由于键不是直接存储的，所以mapping不支持直接遍历。
                                    如果需要遍历，您需要在合约中维护一个单独的键数组。
                            */
    //存储结构                                                      
    struct toDo{
        string name;
        Status status; 
    }

    //数组存放toDo
    toDo[] public list;                         // ? -> 哪些数据类型需要在声明时设置可见性 => 状态变量 √

    //用mapping设置任务ID
    mapping(uint => toDo) public tasks; // 用任务ID映射到任务       //mapping ? 可映射的数据类型 √
    mapping(uint => uint) public taskIndex; // 用任务ID映射到任务的下标     
    uint public taskCounter;

    /*
        映射规则：
        *** 映射的_KeyType只能选择solidity默认的类型，比如uint，address等，不能用自定义的结构体。
            而_ValueType可以使用自定义的类型。下面这个例子会报错，因为_KeyType使用了我们自定义的结构体：
    */


    //初始化结构，但constructor构造函数只可在创建合约时调用一次

    event record(uint id, string _name, Status _status);

    //创建待办事务, 存放在数组内
    function createToDo(string memory _name) external{
        // ? -> 函数可见性和功能的修饰 什么时候用什么  √
            /*
                可见性：
                    public：所有地址（包括外部地址）都可以调用合约中的public函数。
                        常用于合约的外部接口或查询函数。
                    external：只有外部地址（其他合约或外部用户）可以调用合约中的external函数。
                        常用于公开的合约接口，用于与其他合约进行互操作。
                    internal：只有合约内部（同一合约内的其他函数）可以调用internal函数。
                        常用于内部逻辑和细节函数，不希望被外部访问。
                    private：只有当前合约内部的其他函数可以调用private函数。
                        常用于内部实现细节，不希望被其他合约或外部用户访问。
                功能/状态 修饰：
                    view：表明函数只读取数据，不修改状态。
                        适用于查询函数，不消耗gas。
                    pure：表明函数既不读取数据也不修改状态，仅执行计算。
                        适用于数学函数或纯粹的计算，不消耗gas。
                    payable：表明函数可以接受以太币转账。
                        通常用于接收资金的函数，如合约的支付函数。
            */      
        // 临时存储创建的toDo

        toDo memory newTask = toDo(_name, Status.unCompleted);

        // 存入数组
        list.push(newTask); 

        // 存储自增的任务ID
        uint taskId = ++taskCounter;

        tasks[taskId] = newTask;            // *** 要用到mapping或地址引用时多想想用 临时变量形成引用关系 -> 存储临时变量多用到memory存储数据 √

        // 使用数组长度作为键存储任务 ID
        taskIndex[taskId] = taskCounter;

        // ? -> 结构struct的初始化
         // 1.赋值初始化 => structName(param1, param2, ...)
        if (list[0].status == Status(0))
            emit record(taskIndex[taskId], _name, Status.unCompleted);
        /*
            // ? 如果枚举类型仅在当前合约定义，那么外部合约在调用当前合约的时候它获取得到的枚举类型返回值应该是怎么样的？
            // -> 答案是枚举类型会被编译器自动转换成 uint8 类型。所以外部合约看到的枚举类型是 uint8 类型。
            //    这是因为 ABI 中没有枚举类型，只有整型，所以编译器会自动执行这样的转换。
            // * 赋予变量enum类型的值 -> value为被封装过的（enum类型的uint8值）
        */
        
    }

    //修改任务名称
    function changeToDo(string memory _name, uint _index) external{         
        list[_index].name = _name;
    }

    //修改完成状态
    function changeCompleted(uint _id, uint8 _status) external{
        tasks[_id].status = Status(_status);
    }

    //根据先前mapping的 -> tasks[taskId]获取任务信息
    function get(uint _id) external view 
                returns(string memory name, Status _status){
            return (tasks[_id].name, tasks[_id].status);
    }

    // ? -> 减少( *多次* 修改或读取状态变量)gas消耗 √
    /*storage 和memory 区别√
        * 起因：合约上数据的访问和修改都会花费 *大量gas* ，所以在合约中尽量减少数据的访问和修改。
        ** 函数级别的storage变量是在函数执行期间创建的，并且只在函数执行期间存在。
            当函数执行完成后，这些变量的值不会永久存储在区块链上，它们会随着函数的结束而销毁。
        *** => storage 和memory 区别
            1.使用memory适用于在函数内部临时存储和处理数据，不需要永久保存在区块链上，但会导致内存拷贝。
                每次函数调用都会创建一个新的 memory 空间，不同函数之间的 memory 数据不共享。
            2.使用storage适用于需要引用合约状态中的数据，以及避免数据拷贝，从而降低Gas成本。
                数据存储在区块链上的永久存储中，对于合约中的不同函数调用都是可见和共享的。
            *** 用storage存储数据可实现数据引用，而使用memory存储会创建一个新的副本，无法实现引用
    */

    /*push()技巧√
        * // 添加任务
        function addTask(string memory _name) public {
            Task storage newTask = tasks.push();
            newTask.name = _name;
            newTask.completed = false;
        ***
        => tasks.push()：这部分使用动态数组tasks的push函数来向数组中添加一个新的元素。
            push函数会返回新元素的存储位置标识符，因为在 Solidity 中，当向动态数组中添加新元素时，会返回新元素的存储位置。
            这个位置可以被视为对新元素的引用。
    }
    */


}