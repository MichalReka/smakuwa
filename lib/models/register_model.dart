import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

class RegisterModel extends ChangeNotifier{
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  TextEditingController repeatPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool passwordTooWeak = false;
  bool emailUsed = false;
  bool undefinedError = false;

  Future register() async{
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text
      );

      await FirebaseFirestore.instance.collection('users').doc(userCredential.user.uid).set({
        'name':nameController.text,
        'image':"",

    });
      emailController.clear();
      nameController.clear();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        passwordTooWeak = true;
      } else if (e.code == 'email-already-in-use') {
        emailUsed = true;
      }
    } catch (e) {
      undefinedError = true;
    }
    passwordController.clear();
    repeatPasswordController.clear();
  }
}