import 'package:flutter/material.dart';
import 'package:smakuwa/models/firebase_handler.dart';
import 'package:smakuwa/screens/account.dart';
import 'file:///C:/Users/Michal/Documents/magister/smakuwa/lib/screens/item_details.dart';
import 'package:smakuwa/screens/item_list.dart';
import 'package:smakuwa/screens/messages.dart';

void main() {

  runApp(MyApp());
}
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    ItemList(),MessagesScreen(),Account()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }  @override
  Widget build(BuildContext context) {
    FirebaseHandler firebaseHandler = new FirebaseHandler();
    firebaseHandler.initializeFlutterFire();
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
          primarySwatch: Colors.lightGreen,
          textTheme: TextTheme(
            headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            headline6: TextStyle(fontSize: 19.0),
            bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          )),

      home: Scaffold(
        body: _widgetOptions[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
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
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,

        ),
      ),
    );
  }
}




