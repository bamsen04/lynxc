import 'package:lynxc/ast/nodes/ast_node.dart';
import 'package:lynxc/ast/nodes/var_decl.dart';

class FunctionDecl extends ASTNode {
  final String returnType;
  final String name;
  final List<VarDecl> parameters;
  final List<ASTNode> body;

  FunctionDecl(this.returnType, this.name, this.parameters, this.body);
}
