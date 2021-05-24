import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smakuwa/models/profile_model.dart';
import 'package:smakuwa/models/item_add_model.dart';
import 'package:smakuwa/models/item_list_model.dart';
import 'package:smakuwa/models/login_model.dart';
import 'package:smakuwa/screens/account.dart';
import 'package:smakuwa/screens/home.dart';
import 'package:smakuwa/screens/item_list.dart';
import 'package:smakuwa/screens/messages.dart';
import 'package:smakuwa/screens/recipes_list.dart';

import 'custom_icons/custom-icons.dart';
import 'models/home_model.dart';

void main(){
  runApp(
    MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => LoginModel()),
      ChangeNotifierProvider(create: (context) => ItemAddModel()),
      ChangeNotifierProvider(create: (context) => ProfileModel()),
      ChangeNotifierProvider(create: (context) => HomeModel()),
      ChangeNotifierProvider(create: (context) => ItemListModel()),
    ],
    child: Smakuwa(),
  ),);
}
class Smakuwa extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
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
      home: Home()
    );
  }
}




