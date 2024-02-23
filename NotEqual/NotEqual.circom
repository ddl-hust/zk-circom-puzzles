pragma circom 2.1.4;


// Input : a , length of 2 .
// Output : c .
// In this exercise , you have to check that a[0] is NOT equal to a[1], if not equal, output 1, else output 0.
// You are free to use any operator you may like . 

// HINT:NEGATION'

include "../node_modules/circomlib/circuits/comparators.circom";

template NOT() {
    signal input in;
    signal output out;

    out <== 1 + in - 2*in; //todo: why this is vaild quadratic constraints
}

template NotEqual() {

    // Your code here.
    signal input a[2];
    signal output c;

    component e = IsEqual();
    component n = NOT();
    e.in[0] <== a[0];
    e.in[1] <== a[1];
    n.in <== e.out;

    c <== n.out;
   
}

component main = NotEqual();