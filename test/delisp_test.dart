import 'package:unittest/unittest.dart';
import 'package:delisp/delisp.dart';

void main() {
  Environment.init();
  initKeywords();

  var lp = new LispParser();
  ev(x) {
    var expr=lp.parse(x);
    return expr.isSuccess?eval(expr.value, Environment.global):expr;
  }

  // lists - pending tests
//  test("(awef . bff)");
//  test("(a b e . b)");
//  test("'(a b)");
//  test("`(foo ,(bar) e)");
//  test("`(a ,@(gee hux)");

  group("List parsing -", () {
    test("nil", () {
      expect(lp.parse("nil").value, equals(DLSymbol.NIL));
      });
    test("single element", () {
      expect(lp.parse("(a)").value, 
        equals(new Cons(new DLSymbol("a"),DLSymbol.NIL)));
    });
    test("single element, explicit nil", () {
      expect(lp.parse("(a . nil)").value, 
        equals(new Cons(new DLSymbol("a"),DLSymbol.NIL)));
    });
    test("single element, quoted empty list", () {
      expect(lp.parse("(a . '())").value, 
        equals(new Cons(new DLSymbol("a"), 
                        new Cons(new DLSymbol("quote"),
                                 new Cons(DLSymbol.NIL, DLSymbol.NIL)))));
    });
    test("two elements", () {
      expect(lp.parse("(a b)").value, 
        equals(new Cons(new DLSymbol("a"), 
                        new Cons(new DLSymbol("b"), DLSymbol.NIL))));
    });
    test("two elements, ends with explicit nil", () {
      expect(lp.parse("(a b . nil)").value, 
        equals(new Cons(new DLSymbol("a"), 
                        new Cons(new DLSymbol("b"), DLSymbol.NIL))));
    });
  });

    
  group("Quote evaluation -", () {
    test("empty list", () {
      expect(ev("()"), equals(ev("nil")));
    });
    test("quoted empty list", () {
      expect(ev("(quote ())"), equals(ev("nil")));
    });
    test("sugar quoted empty list", () {
      expect(ev("'()"), equals(ev("nil")));
    });
  });
}