import 'package:lynxc/ast/nodes/expression.dart';

class VariableExpr extends Expression {
  final String name;
  VariableExpr(this.name);
}