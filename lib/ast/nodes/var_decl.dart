import 'package:lynxc/ast/nodes/ast_node.dart';
import 'package:lynxc/ast/nodes/expression.dart';

class VarDecl extends ASTNode {
  final String type;
  final String name;
  final Expression? initializer;
  VarDecl(this.type, this.name, this.initializer);
}