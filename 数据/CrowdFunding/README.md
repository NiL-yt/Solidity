# 众筹合约

<!-- markdownlint-disable MD047 -->

## 代码规范

- 代码中各部分的组成顺序如下：
  - pragma 语句
  - import 语句
  - interface
  - library
  - contract
- 在 interface、library 或 contract 中，各组成部分顺序如下：
  - 类型/结构声明(enum，struct)
  - 状态变量
    - 数组
    - 整型/字符串
    - 地址
    - 映射
  - 事件
  - 函数
