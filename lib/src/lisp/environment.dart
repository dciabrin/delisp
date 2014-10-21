part of delisp;

class Environment {
  static final Environment global=new Environment();
  
  static init() {
    global.funcs[new DLSymbol("+")] = new DLFunction.withNative(
        [new DLSymbol("A"), new DLSymbol("B")],
        (a,b) {return a + b;});
    global.funcs[new DLSymbol("=")] = new DLFunction.withNative(
        [new DLSymbol("A"), new DLSymbol("B")],
        (a,b) {return (a == b)?DLSymbol.TRUE:DLSymbol.NIL;});
  }
  
  Map<DLSymbol,dynamic> vars;
  Map<DLSymbol,DLFunction> funcs;
  Environment next;

  Environment(){
    vars=new Map<DLSymbol,dynamic>();
    funcs=new Map<DLSymbol,DLFunction>();
    next=null;
  }
  Environment.fromEnv(Environment env){
    vars=new Map<DLSymbol,dynamic>();
    funcs=env.funcs;
    next=env;
  }
}
