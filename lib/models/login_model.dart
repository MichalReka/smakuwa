import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

class LoginModel with ChangeNotifier{
  bool loggedIn = false;
  bool launchError = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool noEmailFound = false;
  bool wrongPassword = false;
  void checkIfLoggedIn(){
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
    //notifyListeners();
  }
  void resetFlags()
  {
    wrongPassword = false;
    noEmailFound = false;
  }
  Future signIn() async{

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text
      );
      loggedIn=true;
      notifyListeners();
      emailController.text="";
      passwordController.text="";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        noEmailFound = true;
      } else if (e.code == 'wrong-password') {
        wrongPassword = true;
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