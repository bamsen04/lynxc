import "package:lynxc/lexer/lexer.dart";
void main() {
  Lexer lexer = Lexer("+-*/();{}.,; == = >= <= < > ! !=\n");
  List tokens = lexer.tokenize();
  for (var token in tokens) { 
    print(token);
  }
}