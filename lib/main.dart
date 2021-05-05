import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smakuwa/models/item_add_model.dart';
import 'package:smakuwa/models/login_model.dart';
import 'package:smakuwa/screens/account.dart';
import 'package:smakuwa/screens/item_list.dart';
import 'package:smakuwa/screens/messages.dart';

import 'custom_icons/custom-icons.dart';

void main() {
  runApp(
    MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => LoginModel()),
      ChangeNotifierProvider(create: (context) => ItemAddModel()),
    ],
    child: MyApp(),
  ),);
}
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    ItemList(),ItemList(),MessagesScreen(),AccountScreen()
  ];
  void initializeFirebase() async
  {
    await Firebase.initializeApp();
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }  @override
  Widget build(BuildContext context) {
    LoginModel firebaseHandler = new LoginModel();
    firebaseHandler.checkIfLoggedIn();
    initializeFirebase();
    return MaterialApp(
      title: 'Smakuwa',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
          primarySwatch: Colors.green,
          textTheme: TextTheme(
            headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            headline6: TextStyle(fontSize: 19.0),
            bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          )),

      home: Scaffold(
        body: _widgetOptions[_selectedIndex],
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
              icon: Icon(Icons.restaurant),
              label: 'Potrawy',
            ),
            BottomNavigationBarItem(
              icon: Icon(CustomIcons.carrot),
              label: 'Produkty',
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
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}




