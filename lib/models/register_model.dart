import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

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

//      await FirebaseFirestore.instance.collection('users').doc(userCredential.user.uid).set({
//        'name':nameController.text,
//        'image':"",
//    });
      await FirebaseChatCore.instance.createUserInFirestore(
        types.User(
          firstName: nameController.text,
          id: userCredential.user.uid, // UID from Firebase Authentication
          imageUrl: "",
          lastName: ""
        ),
      );
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user.uid).update({
        'uid':userCredential.user.uid
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