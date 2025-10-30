import 'package:lynxc/ast/nodes/ast_node.dart';
import 'package:lynxc/ast/nodes/expression.dart';

class FuncStmt extends ASTNode {
  final List<Expression> expressions;
  final String functionName;
  FuncStmt(this.expressions, this.functionName);
}