import 'package:lynxc/ast/ast_printer.dart';
import 'package:lynxc/ast/parser.dart';
import "package:lynxc/lexer/lexer.dart";
import 'dart:io';

import 'package:lynxc/lexer/token.dart';

void main() {
  String source = File("test.lynx").readAsStringSync();

  Lexer lexer = Lexer(source);
  List<Token> tokens = lexer.tokenize();
  for (var token in tokens) { 
    print(token);
  }

  Parser parser = Parser(tokens);
  var program = parser.parse();
  printAST(program);
}