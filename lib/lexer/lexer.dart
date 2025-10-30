import 'token.dart';
import 'token_type.dart';

class Lexer {
  final String sourceCode;
  
  int line = 1;
  int current = 0;
  int start = 0;

  String buffer = "";
  List<Token> tokens = [];

  Lexer(this.sourceCode);

  List<Token> tokenize() {
    tokens.clear();

    while (!isEndOfSource()) {
      start = current;
      scanTokens();
    }

    tokens.add(Token(TokenType.eof, "", null, line));
    return tokens;
  }

  void scanTokens() {
    String c = advance();
    
    switch (c) {
      case '(':
        addToken(TokenType.lparen);
        break;
      case ')':
        addToken(TokenType.rparen);
        break;
      case '{':
        addToken(TokenType.lbrace);
        break;
      case '}':
        addToken(TokenType.rbrace);
        break;
      case ';':
        addToken(TokenType.semicolon);
        break;
      case ',':
        addToken(TokenType.comma);
        break;
      case '.':
        addToken(TokenType.dot);
        break;
      case '+':
      case '-':
      case '*':
      case '/':
      case '^':
        addToken(TokenType.operator);
        break;
      case '=':
        if (match('=')) {
          addToken(TokenType.operator); // '=='
        } else {
          addToken(TokenType.assign); // '='
        }
        break;
      case '>':
      case '<':
        if (match('=')) {
          addToken(TokenType.operator); // '>=', '<='
        } else {
          addToken(TokenType.operator); // '>', '<'
        }
        break;
      case '!':
        if (match('=')) {
          addToken(TokenType.operator); // '!='
        } else {
          addToken(TokenType.operator); // '!'
        }
        break;

      case ' ':
      case '\r':
      case '\t':
        // Ignore whitespace.
        break;
      case '\n':
        line++;
        break;

      case '"':
        string();
        break;

      default:
      if (isDigit(c)) {
        number();
      } else if (isAlpha(c)) {
        identifier();
      } else {
        throw Exception('Unexpected character "$c" at line $line');
      }
    }
  }

  void number() {
    while (isDigit(peek())) advance();

    // Handle decimals
    if (peek() == '.' && isDigit(peekNext())) {
      advance(); // consume '.'
      while (isDigit(peek())) advance();
    }

    String value = sourceCode.substring(start, current);
    addTokenWithLiteral(TokenType.number, value);
  }

  void string() {
    while (peek() != '"' && !isEndOfSource()) {
      if (peek() == '\n') line++;
      advance();
    }

    if (isEndOfSource()) throw Exception('Unterminated string at line $line');

    advance(); // closing "

    String value = sourceCode.substring(start + 1, current - 1);
    addTokenWithLiteral(TokenType.string, value);
  }

  void identifier() {
    while (isAlphaNumeric(peek())) advance();

    String text = sourceCode.substring(start, current);

    // Define keywords
    Map<String, TokenType> keywords = {
      "void": TokenType.keyword,
      "int": TokenType.keyword,
      "float": TokenType.keyword,
      "string": TokenType.keyword,
      "bool": TokenType.keyword,
      "true": TokenType.keyword,
      "false": TokenType.keyword,
      "if": TokenType.keyword,
      "else": TokenType.keyword,
      "while": TokenType.keyword,
      "for": TokenType.keyword,
      "return": TokenType.keyword,
    };

    TokenType type = keywords[text] ?? TokenType.identifier;
    addToken(type);
  }


  bool match(String expected) {
    if (isEndOfSource()) return false;
    if (sourceCode[current] != expected) return false;

    current++;
    return true;
  }

  void addTokenWithLiteral(TokenType type, String? literal) {
    String text = sourceCode.substring(start, current);
    tokens.add(Token(type, text, literal, line));
  }

  void addToken(TokenType type) {
    addTokenWithLiteral(type, null);
  }

  String advance() {
    return sourceCode[current++];
  }

  bool isEndOfSource() {
    return current >= sourceCode.length;
  }

  bool isDigit(String c) => c.codeUnitAt(0) >= 48 && c.codeUnitAt(0) <= 57;
  bool isAlpha(String c) {
    int code = c.codeUnitAt(0);
    return (code >= 65 && code <= 90) || // A-Z
          (code >= 97 && code <= 122) || // a-z
          c == '_';
  }
  bool isAlphaNumeric(String c) => isAlpha(c) || isDigit(c);

  String peek() {
    if (isEndOfSource()) return '\u0000';
    return sourceCode[current];
  }

  String peekNext() {
    if (current + 1 >= sourceCode.length) return '\u0000';
    return sourceCode[current + 1];
  }
}