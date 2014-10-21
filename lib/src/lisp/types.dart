part of delisp;

class DLSymbol {
  static Map<String, DLSymbol> _cache;
  static final DLSymbol TRUE=new DLSymbol("t");
  static final DLSymbol NIL=new DLSymbol("nil");

  final String name;

  factory DLSymbol(String name) {
    if (_cache == null) {
      _cache = {};
    }

    if (_cache.containsKey(name)) {
      return _cache[name];
    } else {
      final symbol = new DLSymbol._internal(name);
      _cache[name] = symbol;
      return symbol;
    }
  }

  DLSymbol._internal(this.name);

  @override
  String toString() => name;
}


class Cons {
  dynamic car, cdr;
  Cons(this.car, this.cdr);

  @override
  bool operator ==(obj) {
    if (obj is! Cons) return false;
    Cons other=obj;
    return this.car==other.car && this.cdr==other.cdr;
  }

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
    if (cdr != DLSymbol.NIL) {
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
  List<DLSymbol> args;
  Function nativeFunc = null;
  var body = null;

  DLFunction(this.args, this.body);

  DLFunction.withNative(this.args, this.nativeFunc);
}
