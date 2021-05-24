import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smakuwa/models/home_model.dart';
import 'package:smakuwa/models/login_model.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeModel>(builder: (context, model, child) {
      return FutureBuilder(
        // Initialize FlutterFire:
        future: model.firebaseInit,
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            return Scaffold(
              body: Container(
                child: Text("Problem z firebase"),
              ),
            );
          }

          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            context.read<LoginModel>().checkIfLoggedIn();
            return Scaffold(
              body:  PageTransitionSwitcher(
                transitionBuilder: (
                    Widget child,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    ) {
                  return FadeThroughTransition(
                    animation: animation,
                    secondaryAnimation: secondaryAnimation,
                    child: child,
                  );
                },
                child: model.getBody(),
              ),
              bottomNavigationBar: BottomNavigationBar(
/*          selectedIconTheme: IconThemeData(
              color: Colors.green[400]
            ),
            unselectedIconTheme: IconThemeData(
                color: Colors.black38
            ),*/
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Colors.green[500],
                unselectedItemColor: Colors.black26,
                selectedFontSize: 12,
                unselectedFontSize: 12,
                showUnselectedLabels: true,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.receipt),
                    label: 'Przepisy',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.shopping_basket),
                    label: 'Ryneczek',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.message),
                    label: 'Wiadomości',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle),
                    label: 'Konto',
                  ),
                ],
                currentIndex: model.currentIndex,
                onTap: model.changeIndex,
              ),
            );
          }

          // Otherwise, show something whilst waiting for initialization to complete
          return CircularProgressIndicator();
        },
      );
    });
  }
}
