# ToDo 待办任务

<!-- markdownlint-disable MD047 -->

## 补差与规范

1. 创建合约所需要的状态变量，明确其数据类型，包含：

   - **数值类型**

     - 整数类型：int、uint
     - 布尔类型：bool
     - 字节类型：byte
     - 字符串类型：string

   - **引用类型**
     - 地址类型：address
     - 定长/动态数组：var[]
     - 映射类型：mapping
   - **自定义类型**
     - 枚举类型：enum

2. 创建事件 event，用于记录合约变量的创建

```solidity
event eName(type param1, type param2, ...)
```

3.创建函数用于处理需求任务

## 本次 ToDo 总结

### 1.枚举 enum

```solidity
enum identifier {
    identifier1,
    identifier2,
    identifier3,
    ...
}
```

```text
当需要变量存在多种且统一(数据类型)的 value(多状态)时,可使用 enum 枚举
```

> **枚举主要用于为`uint8`分配名称，使程序易于阅读和维护。**
> 枚举（Enum）定义的是一组有限的命名值，它们代表了一种数据类型，用于表示某种状态或选项。枚举定义的是一组可能的值，而不是单独的变量。

- 注意:赋予变量`enum`类型的值 -> `value`为被封装过的（enum 类型的 uint8 值）

> 问:如果枚举类型仅在当前合约定义，那么外部合约在调用当前合约的时候它获取得到的枚举类型返回值应该是怎么样的？
>
> > - 答:是枚举类型会被编译器自动转换成 uint8 类型。所以外部合约看到的枚举类型是 uint8 类型。
> >   这是因为 ABI 中没有枚举类型，只有整型，所以编译器会自动执行这样的转换。
>
> **`enum`类型的变量可以和`uint8`实现互转,可以在传参是使用显式转换传入`enum`参数**

### 2.映射 mapping

```solidity
mapping(_KeyType => _ValueType) visibility identifier
```

1. mapping 的使用:
   - 键（Keys）的存储：mapping 中的键不是直接存储的。相反，它们通过一个哈希函数处理以确定值的存储位置。这意味着您无法遍历或获取 mapping 中所有的键，因为它们本身并不存储在 mapping 中。
   - 动态大小：mapping 是动态大小的，意味着它可以存储无限数量的键值对，只要有足够的 gas 来处理交易。
   - 不支持遍历：由于键不是直接存储的，所以 mapping 不支持直接遍历。如果需要遍历，您需要在合约中维护一个单独的键数组。
2. mapping 的映射规则:
   - \_KeyType: 只能选择 solidity 默认的类型，比如 uint，address 等，不能用自定义的结构体
   - \_ValueType: 可以使用自定义的类型。

### 3.状态变量

1. 状态变量的声明需要设置可见性`visibility`

   - <sapn id="visibility">(函数)可见性</sapn>:
     1.public：所有地址（包括外部地址）都可以调用合约中的 public 函数。常用于合约的外部接口或查询函数。

     2.external：只有外部地址（其他合约或外部用户）可以调用合约中的 external 函数。常用于公开的合约接口，用于与其他合约进行互操作。

     3.internal：只有合约内部（同一合约内的其他函数）可以调用 internal 函数。常用于内部逻辑和细节函数，不希望被外部访问。

     4.private：只有当前合约内部的其他函数可以调用 private 函数。常用于内部实现细节，不希望被其他合约或外部用户访问。

     > **函数的可见性同状态变量的可见性一样**

### 4.函数功能修饰

> [函数状态/功能可见性](#visibility)

- view：表明函数只读取数据，不修改状态。适用于查询函数，不消耗 gas。
- pure：表明函数既不读取数据也不修改状态，仅执行计算。适用于数学函数或纯粹的计算，不消耗 gas。
- payable：表明函数可以接受以太币转账。通常用于接收资金的函数，如合约的支付函数。

### 5.storage 和 memory

- **两者区别**
  1. 使用 `memory` 适用于在函数内部临时存储和处理数据，不需要永久保存在区块链上，但会导致内存拷贝。每次函数调用都会创建一个新的 memory 空间，不同函数之间的 memory 数据不共享。
  2. 使用 `storage` 适用于需要引用合约状态中的数据，以及避免数据拷贝，从而降低 Gas 成本。数据存储在区块链上的永久存储中，对于合约中的不同函数调用都是可见和共享的。

> **注意:用 `storage` 存储数据可实现数据引用，而使用 `memory` 存储会创建一个新的副本，无法实现引用**
> 函数级别的 `storage` 变量是在函数执行期间创建的，并且只在函数执行期间存在。当函数执行完成后，这些变量的值不会永久存储在区块链上，它们会随着函数的结束而销毁。

## 细节点

1. 当存在引用关系时,可使用临时变量`temp`暂存引用地址,_使用`memory`修饰临时变量_
2. **巧用 push()返回值**

   ```solidity
   // 添加任务
   function addTask(string memory _name) public {
        Task storage newTask = tasks.push();
        newTask.name = _name;
        newTask.completed = false;
   ```

   - tasks.push()：这部分使用动态数组 tasks 的 push 函数来向数组中添加一个新的元素。push 函数会返回新元素的存储位置标识符，因为在 Solidity 中，当向动态数组中添加新元素时，会返回新元素的存储位置。这个位置可以被视为对新元素的引用。

3. 减少 `gas` 消耗
   - 批量操作：将多个状态变量的修改合并为一个函数调用，以减少函数调用的开销。这可以通过将多个修改操作放在一个函数中来实现，而不是分别调用多个函数。这可以减少交易的开销，因为每个函数调用都会产生额外的 gas 成本。
   - 局部变量：在函数内部使用局部变量来缓存状态变量的值，以减少多次读取状态变量的 gas 消耗。读取局部变量通常比读取状态变量更便宜，因为它们不需要在区块链上进行读取操作。
