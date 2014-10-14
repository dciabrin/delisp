import "package:delisp/delisp.dart";

void main() {

  var lp = new LispParser();
  test(x) => print(lp.parse(x)); 

  Environment.init();
  
  // lists
  test("'()");
  test("nil");
  test("(a)");
  test("(a . '()");
  test("(a b)");
  test("(a b . nil)");
  test("(awef . bff)");
  test("(a b e . b)");
  test("'(a b)");
  test("`(foo ,(bar) e)");
  test("`(a ,@(gee hux)");
  
  // strings
  test('"foo"');
  test('"foo\\nbar"');
  
  // READ-EVAL-PRINT... 
  var expr=lp.parse("(+ 1 2)");
  print(expr);
  var value=eval(expr.value, Environment.global);
  print(value);
  // ONE STEP AWAY FROM THE REPL :)
}
