// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0; //版本指令
contract TodoList {

    //使用枚举自定义状态Status
    enum Status {
        unCompleted,
        inProgress,
        Completed,
        Cancelled
    }

    //创建结构体toDo，存储待办事务
    struct toDo {
        string name;
        Status status;
    }

    //创建数组list，存放toDo
    toDo[] public list;

    //用mapping映射任务ID到toDo
    mapping(uint => toDo) public tasks;

    //用任务ID映射到任务的下标
    mapping(uint => uint) public taskIndex;
    
    //任务ID自增器
    uint public taskCounter;


    //定义事件，用于-记录-待办事务的创建、更新、删除
    event record(uint id, string _name, Status _status);

    //创建待办事务, 存放在数组内
    function createToDo (string memory _name) external {
        //创建待办事务
        toDo memory newToDo = toDo({
            name: _name,
            status: Status.unCompleted
        });
        //将待办事务存放在数组内
        list.push(newToDo);
        //将待办事务存放在mapping内
        tasks[taskCounter] = newToDo;
        //将待办事务的下标存放在mapping内
        taskIndex[taskCounter] = list.length - 1;
        //任务ID自增
        taskCounter++;
        //触发事件，记录待办事务的创建
        emit record(taskCounter, _name, Status.unCompleted);
    }

    //获取待办事务
    function getToDo (uint _id) external view returns (string memory, Status) {
        return (tasks[_id].name, tasks[_id].status);
    }

    //更新待办事务
    function updateToDo (uint _id, string memory _name, uint8 _status) external {
        //更新待办事务
        toDo memory _toDo = toDo({
            name: _name,
            status: Status(_status)
        });
        //更新数组内的待办事务
        list[taskIndex[_id]] = _toDo;
        tasks[_id] = _toDo;
        emit record(_id, _name, Status(_status));
    }

    //删除待办事务
    function deleteToDo (uint _id) external {
        delete list[taskIndex[_id]];
        delete tasks[_id];
        emit record(_id, "", Status.Cancelled);
    }

    //获取待办事务列表
    function getToDoList () external view returns (toDo[] memory) {
        return list;
    }

    //获取待办事务列表
    function gettasks () external view returns (toDo[] memory) {
        //创建临时数组，存放待办事务
        toDo[] memory _tasks = new toDo[](taskCounter);
        //遍历待办事务
        for (uint i = 0; i < taskCounter; i++) {
            _tasks[i] = tasks[i];
        }
        return _tasks;
    }
}