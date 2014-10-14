part of delisp;

class Environment {
  static final Environment global=new Environment();
  
  static init() {
    global.funcs[new Symbol("+")] = new DLFunction.withNative(
        [new Symbol("A"), new Symbol("B")],
        (a,b) {return a + b;});              
  }
  
  Map<Symbol,dynamic> vars;
  Map<Symbol,DLFunction> funcs;
  Environment next;

  Environment(){
    vars=new Map<Symbol,dynamic>();
    funcs=new Map<Symbol,DLFunction>();
    next=null;
  }
}
