# circom 基础

- 主组件的所有输出信号都是公共的（并且不能设为私有），如果没有另外声明，则主组件的输入信号是私有的
- 信号是不可变的，这意味着一旦为它们分配了值，该值就不能再更改。因此，如果一个信号被分配两次，就会产生编译错误

- 当使用变量(`var`)时，Circom 的行为就像普通的类 C 语言一样。支持运算符 =、==、>=、<=、!=、++ 和 -- 。<--、<== 和 === 运算符用于信号，而不是变量
下面是一些错误的案例
```js
signal a;
a = 2; // using a variable assignment for a signal

var v;
v <-- a + b; // using a signal assignment for a variable is not allowed
```

- signals are field elements, and && is not a valid operator for field elements
    这就是为啥在AND()里面不能直接使用&&



>Linear expression: an expression where only addition is used. It can also be written using multiplication of variables by constants. For instance, the expression 2*x + 3*y + 2 is allowed, as it is equivalent to x + x + y + y + y + 2.
Quadratic expression: it is obtained by allowing a multiplication between two linear expressions and addition of a linear expression: A*B - C, where A, B and C are linear expressions. For instance, (2*x + 3*y + 2) * (x+y) + 6*x + y – 2.
Non quadratic expressions: any arithmetic expression which is not of the previous kind.
circom allows programmers to define the constraints that define the arithmetic circuit. All constraints must be quadratic of the form A*B + C = 0, where A, B and C are linear combinations of signals. circom will apply some minor transformations on the defined constraints in order to meet the format A*B + C = 0:

quote from:https://docs.circom.io/circom-language/constraint-generation/


这段关于signal约束的话如何理解,一开始以为是只能有形如: A*B+C的二次约束
但是在下面的非门电路中好像也只有线性约束
```
template NOT() {
    signal input in;
    signal output out;

    out <== 1 + in - 2*in; //todo: why 
}
```


# 常用电路

```js
template IsEqual() {
    signal input in[2];
    signal output out;

    component isz = IsZero();

    in[1] - in[0] ==> isz.in;

    isz.out ==> out;
}
```

```js
template And() {
    signal input in[2];
    signal output c;
    
    // force inputs to be zero or one,eg if not meet, then Assert Failed. 官方的实现没有做(0,1)限制,可以理解为大于0就是真
    in[0] === in[0] * in[0];
    in[1] === in[1] * in[1];
    
    // c will be 1 iff in[0] and in[1] are 1
    c <== in[0] * in[1];
}
```


# 解题记录


## Equality 

这里实现了一个IsZero的判断,考虑下为什么不直接这么写
```
template IsZero() {
  signal input in;
  signal output out;

  out <== in == 0 ? 1 : 0;
}
```
运行上述代码,会报错`error[T3001]: Non quadratic constraints are not allowed!`
在做out 约束的时候不是一个有效的约束


## Poseidon

参考 https://zkrepl.dev/

`npm install iden3/circomlib`
注意circom import poseidon 路径 `include "../node_modules/circomlib/circuits/poseidon.circom";`


## NotEqual

一些电路的组合,Equal+NOT


# 参考

https://www.rareskills.io/post/circom-tutorial
https://github.com/iden3/circomlib/blob/master/circuits/gates.circom