part of delisp;

class Symbol {
  static Map<String, Symbol> _cache;
  static final Symbol TRUE=new Symbol("t");
  static final Symbol NIL=new Symbol("nil");
  
  final String name;

  factory Symbol(String name) {
    if (_cache == null) {
      _cache = {};
    }

    if (_cache.containsKey(name)) {
      return _cache[name];
    } else {
      final symbol = new Symbol._internal(name);
      _cache[name] = symbol;
      return symbol;
    }
  }

  Symbol._internal(this.name);
  
  @override
  String toString() => name;
}


class Cons {
  dynamic car, cdr;
  Cons(this.car, this.cdr);

  @override
  String toString() {
    var buf = new StringBuffer();
    buf.write("(");
    buf.write(consToString());
    buf.write(")");
    return buf.toString();
  }

  String consToString() {
    var buf = new StringBuffer();
    buf.write(car);
    if (cdr != Symbol.NIL) {
      if (cdr is Cons) {
        buf.write(" ");
        buf.write(cdr.consToString());
      } else {
        buf.write(" . ");
        buf.write(cdr);
      }
    }
    return buf.toString();
  }
}

class DLFunction {
  List<Symbol> args;
  Function nativeFunc = null;
  var body = null;
  
  DLFunction(this.args, this.body);
  
  DLFunction.withNative(this.args, this.nativeFunc);
}
