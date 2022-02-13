import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PasswordResetModel extends ChangeNotifier {
  TextEditingController emailController = new TextEditingController();

  Future<bool> passwordReset() async {
    try {
      final user = await FirebaseAuth.instance.sendPasswordResetEmail(
          email: emailController.text);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}