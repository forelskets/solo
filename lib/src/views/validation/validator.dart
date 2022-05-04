import 'dart:async';

String pass = '';

class Validator {
  final emailValidate = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink) {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);
      if (regex.hasMatch(email)) {
        sink.add(email);
      } else {
        sink.addError('Enter a valid email');
      }
    },
  );

  final passwordValidate = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{5,}$';
    RegExp regExp = new RegExp(pattern);
    if (password.length > 5 && regExp.hasMatch(password)) {
      sink.add(password);
      pass = password;
    } else {
      sink.addError('Invalid password');
    }
  });

  final cpasswordValidate = StreamTransformer<String, String>.fromHandlers(
      handleData: (cpassword, sink) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{5,}$';
    RegExp regExp = new RegExp(pattern);
    if (cpassword.length > 5 &&
        regExp.hasMatch(cpassword) &&
        pass == cpassword) {
      sink.add(cpassword);
    } else {
      sink.addError('Password didn\'t match with confirm password');
    }
  });

  final usernameValidation = StreamTransformer<String, String>.fromHandlers(
      handleData: (username, sink) {
    if (username.isNotEmpty) {
      sink.add(username);
    } else {
      sink.addError('You must have to write your name');
    }
  });
}
