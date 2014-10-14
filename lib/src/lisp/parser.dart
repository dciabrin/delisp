part of delisp;

class LispGrammar extends CompositeParser {

  @override
  void initialize() {
    def('start', ref('atom').end());

    def('atom', ref('list')
        | ref('number') 
        | ref('string') 
        | ref('symbol')
        | ref('quote')
        | ref('quasiquote')
        | ref('splice')
        | ref('unquote')
    );


    def('list', char('(') & ref('innerlist') & char(')'));

    def('innerlist', 
          (ref('atom') & ref('dot') & ref('atom')) 
        | (ref('atom') & ref('innerlist'))
        | ref('atom'));

    def('dot', char('.').trim());

    def('quote', char('\'') & (string("()") | ref('atom')));
    def('quasiquote', char('`') & ref('atom'));
    def('splice', string(',@') & ref('list'));
    def('unquote', char(',') & ref('list'));
    

    def('string', (char('"') & ref('innerstring').star() & char('"'))
        .flatten().trim());
    
    def('innerstring',
          pattern('^"')
        | (char('\\') & any()) );

    // borrowed form petitparser
    def('symbol', (pattern('a-zA-Z!#\$%&*/:<=>?@\\^_|~+-') & pattern('a-zA-Z0-9!#\$%&*/:<=>?@\\^_|~+-').star()).flatten().trim());

    def('number',digit().plus().flatten().trim());
  }

  /// Defines a bracketed reference.
  Parser bracket(String brackets, String reference) {
    return char(brackets[0]).seq(ref(reference)).seq(char(brackets[1]));
  }
}


class LispParser extends LispGrammar {

  @override
  void initialize() {
    super.initialize();

    action('number', onNumber);
    action('symbol', onSymbol);
    action('innerlist', onInnerList);
    action('list', onList);
    action('quote', onQuote);
    action('quasiquote', onQuasiQuote);
    action('unquote', onUnquote);
    action('splice', onSplice);
  }

  onNumber(elem) => int.parse(elem);
  
  onSymbol(elem) => new Symbol(elem);
    
  onList(elem) {
    // strip ['(', xxx, ')']
    return (elem is List) ? elem[1] : elem;
  }
  
  onInnerList(elem) {
    if (elem is List) {
      // cons dot?
      if (elem[1] is String && elem[1] == ".") {
        return new Cons(elem[0], elem[2]);
      } else {
        // cdr is already a parsed cons
        return new Cons(elem[0], elem[1]);
      }
    } else {
      return new Cons(elem, Symbol.NIL);
    }
  }
  
  onQuote(elem) {
    if(elem[1]=="()") {
      return Symbol.NIL;
    } else {
      return new Cons(new Symbol("\\\'"), new Cons(elem[1], Symbol.NIL));
    }
  }
 
  onQuasiQuote(elem) => 
    new Cons(new Symbol("\\\`"), new Cons(elem[1], Symbol.NIL));

  onUnquote(elem) => 
    new Cons(new Symbol("\\\,"), new Cons(elem[1], Symbol.NIL));

  onSplice(elem) => 
    new Cons(new Symbol("\\\,@"), new Cons(elem[1], Symbol.NIL));
}
