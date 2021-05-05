import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smakuwa/models/account_model.dart';
import 'package:smakuwa/models/login_model.dart';
import 'package:smakuwa/screens/login_screen.dart';

class AccountScreen extends StatelessWidget {

  Widget _profilePhoto() {
    return Center(
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              image: AssetImage('assets/img/placeholder.png'),
              fit: BoxFit.fill),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginModel>(builder: (context, loginModel, child) {
      if (loginModel.loggedIn) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Konto"),
          ),
          body: Container(
              margin: EdgeInsets.all(15),
              child: ListView(
                children: [
                  _profilePhoto(),
                  Text("Jan Kowalski"),
                  InkWell(
                    onTap: () {},
                    child: Card(
                      child: ListTile(),
                    ),
                  ),
                  InkWell(
                    onTap: () => loginModel.logout(),
                    child: Card(
                      child: Text("Wyloguj się"),
                    ),
                  ),
                ],
              )),
        );
      } else {
        return LoginScreen();
      }
    });
  }
}
