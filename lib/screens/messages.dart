import 'package:flutter/material.dart';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smakuwa/models/login_model.dart';
import 'package:smakuwa/screens/login_screen.dart';

class MessagesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginModel>(builder: (context, login, child) {
      if (login.loggedIn) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Wiadomości"),
          ),
          body: Container(
            margin: EdgeInsets.all(15),
            child: Text('Wiadomosci')
          ),
        );
      } else {
        return LoginScreen();
      }
    });
  }
}
