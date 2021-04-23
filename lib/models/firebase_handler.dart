import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseHandler{
  static bool loggedIn = false;
  static bool launchError = false;
  Future initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      User currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        loggedIn = true;
      } else {
        loggedIn = false;
      }
    } catch (e) {
      launchError = true;
    }
  }
}