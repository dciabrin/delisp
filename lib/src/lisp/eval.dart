part of delisp;

dynamic eval(dynamic atom, Environment env) {
  if (atom is Cons) {
    return evalCons(atom, env);
  } 
  // num, string
  return atom;
}

dynamic evalCons(Cons cons, Environment env) {
  if (cons.car is! Symbol) {
    throw new StateError("not a symbol");
  }
  
  DLFunction dlfun = env.funcs[cons.car];
  if (dlfun == null) {
    throw new StateError("unknown function: "+cons.car.name);
  }
  List<dynamic> args=[];
  for (dynamic ic=cons.cdr; ic!=Symbol.NIL; ic=ic.cdr) {
    args.add(eval(ic.car,env));
  }
  
  return Function.apply(dlfun.nativeFunc, args);
}