// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0; //版本指令

//1.定义合约 -> 合约（程序）入口
contract ZombieFactory  {

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    //7.定义事件
    event NewZombie(uint zombieId, string name, uint dna);

    //8.定义映射
    mapping (uint => address) public zombieToOwner; //僵尸id -> 拥有者地址
    mapping (address => uint) public ownerZombieCount; //拥有者地址 -> 拥有僵尸数量



    //2.定义结构体
    struct Zombie{
        string name;
        uint dna;
    }

    //3.定义数组
    Zombie[] public zombies;


    //4.定义函数
    function _createZombie(string memory _name, uint _dna) internal{
        zombies.push(Zombie(_name,_dna));
        uint id = zombies.length - 1;
        /*9.定义映射的值
            1、首先，在得到新的僵尸 id 后，更新 zombieToOwner 映射，在 id 下面存入 msg.sender。
            2、然后，我们为这个 msg.sender 名下的 ownerZombieCount 加 1。
        */
        zombieToOwner [id] = msg.sender;
        ownerZombieCount [msg.sender]++;
        emit NewZombie(id, _name, _dna);
    }



    //5.根据随机的-字符串-创建随机的16位数
    function _generateRandomDna(string memory _str) private view returns(uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }



    //6.根据 随机数rand 创建随机僵尸
    function createRandomZombie(string memory _name) public {
        //10.采用require添加限制条件 -> 一个地址只能拥有一个僵尸 
        require(ownerZombieCount [msg.sender] == 0, "only one zombie");
       uint randDna =  _generateRandomDna(_name);
       _createZombie(_name, randDna);
    }


}

