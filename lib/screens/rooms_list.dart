import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smakuwa/models/login_model.dart';
import 'package:smakuwa/screens/login_screen.dart';
class RoomList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if(context.watch<LoginModel>().loggedIn)
      {
        return Scaffold(
          appBar: AppBar(title: Text("Wiadomości"),),
          body: Container(
            
          ),
        );
      }
    else
      {
        return LoginScreen();
      }
  }
}
