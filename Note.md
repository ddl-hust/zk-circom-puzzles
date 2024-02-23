# circom 基础

- 主组件的所有输出信号都是公共的（并且不能设为私有），如果没有另外声明，则主组件的输入信号是私有的
- 信号是不可变的，这意味着一旦为它们分配了值，该值就不能再更改。因此，如果一个信号被分配两次，就会产生编译错误

- 信号是不可变的，并且旨在成为 R1CS 的列之一


- https://www.rareskills.io/post/circom-tutorial
- Use the IsEqual template rather than === unless you are constraining a multiplication of signals
circom 里面===是用来做signal 约束的,没法直接做比较,简单理解就是这个符号已经做了重载
**将信号与常量进行比较时，请使用 IsEqual 组件，而不是 ===**
```js
template IsEqual() {
    signal input in[2];
    signal output out;

    component isz = IsZero();

    in[1] - in[0] ==> isz.in;

    isz.out ==> out;
}
```


在 Circcom 中比较数字的陷阱
- https://docs.circom.io/circom-language/basic-operators/#boolean-operators 文档里面提到的运算符应该都只能用在var上



下面这个例子显示了如何在信号上实现AND逻辑
```js
template And() {
    signal input in[2];
    signal output c;
    
    // force inputs to be zero or one
    in[0] === in[0] * in[0];
    in[1] === in[1] * in[1];
    
    // c will be 1 iff in[0] and in[1] are 1
    c <== in[0] * in[1];
}
```


# 解题记录


## Poseidon

参考 https://zkrepl.dev/

`npm install iden3/circomlib`
注意circom import poseidon 路径 `include "../node_modules/circomlib/circuits/poseidon.circom";`