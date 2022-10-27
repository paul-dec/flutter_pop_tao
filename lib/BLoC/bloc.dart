import 'dart:async';
import 'package:bored_board/BLoC/validators.dart';

class Bloc extends Object with Validators {
  final _emailController = StreamController<String>.broadcast();
  final _passwordController = StreamController<String>.broadcast();
  final _pseudoController = StreamController<String>.broadcast();

  Stream<String> get email => _emailController.stream.transform(validateEmail);
  Stream<String> get password =>
      _passwordController.stream.transform(validatePassword);
  Stream<String> get pseudo =>
      _pseudoController.stream.transform(validatePseudo);

  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;
  Function(String) get changePseudo => _pseudoController.sink.add;

  void dispose() {
    _emailController.close();
    _passwordController.close();
    _pseudoController.close();
  }
}

final bloc = Bloc();
