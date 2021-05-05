import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

class LoginModel with ChangeNotifier{
  bool loggedIn = false;
  bool launchError = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Future checkIfLoggedIn() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      User currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        loggedIn = true;
      } else {
        loggedIn = false;
      }
    } catch (e) {
      launchError = true;
    }
    notifyListeners();
  }
  Future signIn() async{
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: nameController.text,
          password: passwordController.text
      );
      loggedIn=true;
      notifyListeners();
      nameController.text="";
      passwordController.text="";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }
  Future logout() async{
    try {
      FirebaseAuth.instance.signOut();
      notifyListeners();
      loggedIn = false;
    } on FirebaseAuthException catch (e) {
      print("Nie można się wylogować");
    }  }

}