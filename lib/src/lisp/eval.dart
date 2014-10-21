part of delisp;

Map<DLSymbol,Function> lispKeywords;

initKeywords()
{
  lispKeywords=new Map<DLSymbol,Function>();
  lispKeywords[new DLSymbol('if')]=evalIf;
  lispKeywords[new DLSymbol('progn')]=evalProgn;
  lispKeywords[new DLSymbol('quote')]=evalQuote;
  lispKeywords[new DLSymbol('defun')]=evalDefun;
  lispKeywords[new DLSymbol('setq')]=evalSetq;
}



dynamic eval(dynamic atom, Environment env) {
  if (atom is Cons) {
    var evalKeyword=lispKeywords[atom.car];
    if (evalKeyword!=null) {
      return evalKeyword(atom, env);
    } else {
      return evalFunCall(atom, env);
    }
  }
  else if ((atom == DLSymbol.NIL)||
           (atom == DLSymbol.TRUE)) {
    return atom;
  }
  // variable
  else if (atom is DLSymbol) {
    return evalVariable(atom, env);
  }
  // num, string
  return atom;
}

dynamic evalVariable(DLSymbol sym, Environment env) {
  dynamic val=null;
  while(val==null&&env!=null) {
    val=env.vars[sym];
    if (val==null) env=env.next;
  }
  return val;
}

dynamic evalMany(dynamic list, Environment env) {
  var lastVal=DLSymbol.NIL;
  while(list != DLSymbol.NIL) {
    lastVal=eval(list.car,env);
    list=list.cdr;
  }
  return lastVal;
}

dynamic evalQuote(Cons quote, Environment env) {
  return quote.cdr.car;
}

dynamic evalProgn(Cons progn, Environment env) {
  return evalMany(progn.cdr, env);
}

dynamic evalIf(Cons ifexpr, Environment env) {
  var cond=eval(ifexpr.cdr.car, env);
  if (cond!=DLSymbol.NIL) {
    return eval(ifexpr.cdr.cdr.car, env);
  } else {
    return evalMany(ifexpr.cdr.cdr.cdr, env);
  }
}

dynamic evalSetq(dynamic setq, Environment env) {
  setq=setq.cdr;
  dynamic val;
  while(setq!=DLSymbol.NIL) {
    DLSymbol sym=setq.car;
    val=eval(setq.cdr.car, env);
    env.vars[sym]=val;
    setq=setq.cdr.cdr;
  }
  return val;
}

dynamic evalDefun(Cons defun, Environment env) {
  DLSymbol fun=defun.cdr.car;
  List<dynamic> args=[];
  for (dynamic ia=defun.cdr.cdr.car; ia!=DLSymbol.NIL; ia=ia.cdr) {
    args.add(ia.car);
  }
  dynamic body=defun.cdr.cdr.cdr;
  env.funcs[fun]=new DLFunction(args,body);
  return fun;
}

dynamic evalFunCall(Cons cons, Environment env) {
  if (cons.car is! DLSymbol) {
    throw new StateError("not a symbol");
  }

  DLFunction dlfun = env.funcs[cons.car];
  if (dlfun == null) {
    throw new StateError("unknown function: "+cons.car.name);
  }
  List<dynamic> args=[];
  for (dynamic ic=cons.cdr; ic!=DLSymbol.NIL; ic=ic.cdr) {
    args.add(eval(ic.car,env));
  }

  if (dlfun.nativeFunc!=null) {
    var ret=Function.apply(dlfun.nativeFunc, args);
    return ret;
  } else {
    Environment envfun=new Environment.fromEnv(Environment.global);
    Iterator<DLSymbol> iname=dlfun.args.iterator;
    for (var val in args) {
      iname.moveNext();
      DLSymbol name=iname.current;
      envfun.vars[name]=val;
    }
    return evalMany(dlfun.body, envfun);
  }
}