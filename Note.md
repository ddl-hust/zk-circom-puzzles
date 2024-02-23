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


```js
template IsEqual() {
    signal input in[2];
    signal output out;

    component isz = IsZero();

    in[1] - in[0] ==> isz.in;

    isz.out ==> out;
}
```


下面这个例子显示了如何在信号上实现AND逻辑 
```js
template And() {
    signal input in[2];
    signal output c;
    
    // force inputs to be zero or one,eg if not meet, then Assert Failed.
    in[0] === in[0] * in[0];
    in[1] === in[1] * in[1];
    
    // c will be 1 iff in[0] and in[1] are 1
    c <== in[0] * in[1];
}
```


# 解题记录


## Equality 

这里实现了一个IsZero的判断,考虑下为什么不直接这么写,circom是[支持三目运算符](https://docs.circom.io/circom-language/basic-operators/#field-elements)
```
template IsZero() {
  signal input in;
  signal output out;

  out <== in == 0 ? 1 : 0;
}
```
运行上述代码,会报错`error[T3001]: Non quadratic constraints are not allowed!`
因为在做out约束的时候不是二次约束,这就是为啥需要先计算一个inv,然后用inv和input做一个二次约束

这种电路的约束是circom电路系统本身的特性


## Poseidon

参考 https://zkrepl.dev/

`npm install iden3/circomlib`
注意circom import poseidon 路径 `include "../node_modules/circomlib/circuits/poseidon.circom";`




# 参考

https://www.rareskills.io/post/circom-tutorial
https://github.com/iden3/circomlib/blob/master/circuits/gates.circom