import 'package:lynxc/ast/nodes/ast_node.dart';
import 'package:lynxc/ast/nodes/function_decl.dart';
import 'package:lynxc/ast/nodes/literal_expression.dart';
import 'package:lynxc/ast/nodes/print_stmt.dart';
import 'package:lynxc/ast/nodes/program.dart';
import 'package:lynxc/ast/nodes/var_decl.dart';
import 'package:lynxc/ast/nodes/variable_expression.dart';

void printAST(ASTNode node, [String indent = ""]) {
  if (node is Program) {
    print("${indent}Program");
    for (var stmt in node.body) {
      printAST(stmt, "$indent  ");
    }
  } else if (node is FunctionDecl) {
    print("${indent}FunctionDecl(${node.name})");
    for (var stmt in node.body) {
      printAST(stmt, "$indent  ");
    }
  } else if (node is FuncStmt) {
    print("${indent}FuncStmt(${node.functionName})");
    printAST(node.expression, "$indent  ");
  } else if (node is VarDecl) {
    print("${indent}VarDecl(${node.type} ${node.name})");
    if (node.initializer != null) printAST(node.initializer!, "$indent  ");
  } else if (node is LiteralExpr) {
    print("${indent}Literal(${node.value})");
  } else if (node is VariableExpr) {
    print("${indent}Variable(${node.name})");
  }
}
