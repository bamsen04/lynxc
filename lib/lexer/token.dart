import 'token_type.dart';

class Token {
  final TokenType type;
  final String lexeme; // the actual string from source code!
  final String? literal; // optional value (for numbers, strings, etc)
  final int line;

  const Token(this.type, this.lexeme, this.literal, this.line);

  @override
  String toString() {
    return '${type.name}("$lexeme") at $line';
  }
}