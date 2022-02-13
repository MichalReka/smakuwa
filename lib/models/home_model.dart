
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smakuwa/screens/account.dart';
import 'package:smakuwa/screens/autocomplete.dart';
import 'package:smakuwa/screens/item_list.dart';
import 'package:smakuwa/screens/mapbox.dart';
import 'package:smakuwa/screens/messages.dart';
import 'package:smakuwa/screens/recipes_list.dart';
import 'package:smakuwa/screens/rooms_list.dart';
import 'package:smakuwa/screens/users.dart';

class HomeModel with ChangeNotifier
{
  final Future<FirebaseApp> firebaseInit = Firebase.initializeApp();
  int currentIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    /*RecipesList(),*/ItemList(),RoomList(),AccountScreen()
  ];
  void changeIndex(int index)
  {
    currentIndex=index;
    notifyListeners();
  }
  Widget getBody()
  {
    return _widgetOptions[currentIndex];
  }
  Future<void> initializeFirebase()
  async {
    await Firebase.initializeApp();
  }
}