import 'package:lynxc/ast/nodes/ast_node.dart';

class FunctionDecl extends ASTNode {
  final String returnType;
  final String name;
  final List<ASTNode> body;
  FunctionDecl(this.returnType, this.name, this.body);
}