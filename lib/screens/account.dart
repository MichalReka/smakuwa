import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smakuwa/custom_icons/custom-icons.dart';
import 'package:smakuwa/models/profile_model.dart';
import 'package:smakuwa/models/login_model.dart';
import 'package:smakuwa/screens/item_list.dart';
import 'package:smakuwa/screens/login_screen.dart';
import 'package:smakuwa/screens/profile_edit.dart';

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
                  Container(margin:EdgeInsets.only(bottom: 30),child: Text("Jan Kowalski", style: Theme.of(context).textTheme.headline4,textAlign: TextAlign.center,)),
                  Card(
                    child: InkWell(
                      onTap: () {},
                      child: ListTile(
                        leading: Icon(Icons.receipt),
                        title: Text("Twoje przepisy"),
                      ),
                    ),
                  ),
                  Card(

                    child: InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder:(BuildContext context) =>
                            ItemList(showOwnedOnly: true,)));
                      },
                      child: ListTile(
                        leading: Icon(Icons.shopping_basket),
                        title: Text("Twój ryneczek"),
                      ),
                    ),
                  ),
                  Divider(),
                  Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder:(BuildContext context) =>
                            ProfileEdit()));
                      },
                      child: ListTile(
                          leading: Icon(Icons.edit),
                          title: Text("Edytuj profil"),
                        ),
                    ),
                  ),
                  Card(
                    child: InkWell(
                      onTap: () {},
                      child: ListTile(
                        leading: Icon(Icons.lock),
                        title: Text("Zmień dane logowania"),
                      ),
                    ),
                  ),
                  Divider(),

                  Card(
                    child: InkWell(
                      onTap: () => loginModel.logout(),
                      child: ListTile(
                        leading: Icon(Icons.logout),
                        title: Text("Wyloguj się"),
                      ),
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
