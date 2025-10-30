import 'package:lynxc/ast/nodes/ast_node.dart';

class Program extends ASTNode {
  final List<ASTNode> body;
  Program(this.body);
}