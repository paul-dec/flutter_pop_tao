import 'dart:async';

class Validators {
  final validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)) {
      sink.add(email);
    } else {
      sink.addError('Enter a valid email');
    }
  });

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length >= 8) {
      sink.add(password);
    } else {
      sink.addError('Password must be at least 8 characters');
    }
  });

  final validatePseudo =
      StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (name.length > 2) {
      sink.add(name);
    } else {
      sink.addError('Pseudo must be at least 3 characters');
    }
  });
}
