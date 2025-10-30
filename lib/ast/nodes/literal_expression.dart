import 'package:lynxc/ast/nodes/expression.dart';

class LiteralExpr extends Expression {
  final String value;
  LiteralExpr(this.value);
}