import 'package:lynxc/ast/nodes/ast_node.dart';
import 'package:lynxc/ast/nodes/expression.dart';
import 'package:lynxc/ast/nodes/function_decl.dart';
import 'package:lynxc/ast/nodes/literal_expression.dart';
import 'package:lynxc/ast/nodes/print_stmt.dart';
import 'package:lynxc/ast/nodes/program.dart';
import 'package:lynxc/ast/nodes/var_decl.dart';
import 'package:lynxc/ast/nodes/variable_expression.dart';
import 'package:lynxc/lexer/token.dart';
import 'package:lynxc/lexer/token_type.dart';

class Parser {
  final List<Token> tokens;
  int current = 0;

  Parser(this.tokens);

  bool isAtEnd() => peek().type == TokenType.eof;
  Token peek() => tokens[current];
  Token previous() => tokens[current - 1];
  Token advance() => !isAtEnd() ? tokens[current++] : tokens[current - 1];
  bool check(TokenType type) => !isAtEnd() && peek().type == type;

  bool match(List<TokenType> types) {
    for (var type in types) {
      if (check(type)) {
        advance();
        return true;
      }
    }
    return false;
  }

  Program parse() {
    List<ASTNode> statements = [];

    while (!isAtEnd()) {
      statements.add(declaration());
    }

    return Program(statements);
  }

  ASTNode declaration() {
    if (match([TokenType.keyword])) {
      String keyword = previous().lexeme;

      if (keyword == "void") {
        return functionDeclaration();
      } else if (keyword == "int") {
        return variableDeclaration(keyword);
      }
    }

    return statement();
  }

  FunctionDecl functionDeclaration() {
    Token name = advance(); // function name
    consume(TokenType.lparen, "Expect '(' after function name.");
    consume(TokenType.rparen, "Expect ')' after parameters.");
    consume(TokenType.lbrace, "Expect '{' before function body.");

    List<ASTNode> body = [];
    while (!check(TokenType.rbrace) && !isAtEnd()) {
      body.add(declaration());
    }

    consume(TokenType.rbrace, "Expect '}' after function body.");
    return FunctionDecl("void", name.lexeme, body);
  }

  VarDecl variableDeclaration(String type) {
    Token name = advance(); // variable name
    Expression? initializer;

    if (match([TokenType.assign])) {
      initializer = expression();
    }

    consume(TokenType.semicolon, "Expect ';' after variable declaration.");
    return VarDecl(type, name.lexeme, initializer);
  }

  ASTNode statement() {
    if (check(TokenType.identifier)) {
      return functionStatement();
    }
    return expressionStatement();
  }

  ASTNode functionStatement() {
    Token tk = advance();

    if (peek().type != TokenType.lparen) {
      return expressionStatement();
    }

    consume(TokenType.lparen, "Expect '(' after function.");
    Expression value = expression();
    consume(TokenType.rparen, "Expect ')' after function.");
    consume(TokenType.semicolon, "Expect ';' after function.");
    return FuncStmt(value, tk.lexeme);
  }

  ASTNode expressionStatement() {
    Expression expr = expression();
    consume(TokenType.semicolon, "Expect ';' after expression.");
    return expr;
  }

  Expression expression() {
    if (check(TokenType.number)) {
      return LiteralExpr(advance().literal ?? "");
    } else if (check(TokenType.string)) {
      return LiteralExpr(advance().literal ?? "");
    } else if (check(TokenType.identifier)) {
      return VariableExpr(advance().lexeme);
    }
    throw Exception("Unexpected expression at ${peek().line}");
  }

  Token consume(TokenType type, String message) {
    if (check(type)) return advance();
    throw Exception("$message at line ${peek().line}");
  }
}
