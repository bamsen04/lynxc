import 'dart:isolate';

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
      default:
        throw UnimplementedError('Unexpected character: $c');
    }
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
}