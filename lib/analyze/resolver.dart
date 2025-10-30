import 'package:lynxc/ast/nodes/ast_node.dart';
import 'package:lynxc/ast/nodes/func_statement.dart';
import 'package:lynxc/ast/nodes/program.dart';
import 'package:lynxc/ast/nodes/var_decl.dart';
import 'package:lynxc/ast/nodes/function_decl.dart';
import 'package:lynxc/ast/nodes/variable_expression.dart';

class Resolver {
  final List<Map<String, bool>> scopes = [];

  Resolver () {
    beginScope();
    define("print");
  }

  void resolve(ASTNode node) {
    if (node is Program) {
      for (var stmt in node.body) {
        resolve(stmt);
      }
    } else if (node is VarDecl) {
      declare(node.name);
      define(node.name);
      if (node.initializer != null) resolve(node.initializer!);
    } else if (node is FunctionDecl) {
      declare(node.name);
      define(node.name);
      beginScope();

      for (var param in node.parameters) {
        define(param.name);
      }

      for (var stmt in node.body) {
        resolve(stmt);
      }
      endScope();
    } else if (node is VariableExpr) {
      if (!isDefined(node.name)) {
        throw Exception("Undefined variable '${node.name}'.");
      }
    } else if (node is FuncStmt) {
      if (!isDefined(node.functionName)) {
        throw Exception("Undefined function '${node.functionName}'.");
      }

      for (var expr in node.expressions) {
        resolve(expr);
      }
    } 
  }

  // --- SCOPE HELPERS ---
  void beginScope() => scopes.add({});
  void endScope() => scopes.removeLast();

  void declare(String name) {
    if (scopes.isEmpty) return;
    var scope = scopes.last;
    if (scope.containsKey(name)) {
      throw Exception("Variable '$name' already declared in this scope.");
    }
    scope[name] = false;
  }

  void define(String name) {
    if (scopes.isEmpty) return;
    scopes.last[name] = true;
  }

  bool isDefined(String name) {
    for (var i = scopes.length - 1; i >= 0; i--) {
      if (scopes[i].containsKey(name)) return scopes[i][name]!;
    }
    return false;
  }
}
