import 'package:lynxc/ast/nodes/ast_node.dart';
import 'package:lynxc/ast/nodes/expression.dart';

class FuncStmt extends ASTNode {
  final Expression expression;
  final String functionName;
  FuncStmt(this.expression, this.functionName);
}