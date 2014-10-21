import "package:delisp/delisp.dart";

void main() {

  Environment.init();
  initKeywords();

  var lp = new LispParser();
  test(x) => print(lp.parse(x)); 
  rep(x) {
    print("> "+x);
    var expr=lp.parse(x);
    print(expr.isSuccess?eval(expr.value, Environment.global):expr);
  };

  // Evaluation of simple forms, output to the console
  // Unit tests are available in a dedicated directory
  rep("(+ 1 2)");
  rep("(= 0 0)");

  rep("(progn 'a 'b 'c)");
  
  rep("(if (= 1 1) 'yes 'no)");
  rep("(if nil 'e 1 2 3)");
  
  rep("(setq x 140)");
  rep("(defun adder (a b) (+ (+ a b) x))");
  rep("(adder 1 2)");
}
