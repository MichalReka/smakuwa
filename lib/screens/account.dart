import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smakuwa/custom_icons/custom-icons.dart';
import 'package:smakuwa/models/profile_model.dart';
import 'package:smakuwa/models/login_model.dart';
import 'package:smakuwa/screens/item_list.dart';
import 'package:smakuwa/screens/login_screen.dart';
import 'package:smakuwa/screens/profile_edit.dart';
//TODO: ZMNIEJSZYC ILOSC WCZYTYWANIA DANYCH O USERZE - WCZYTYWANE SA DWA RAZY

class AccountScreen extends StatelessWidget {
  Widget _profilePhoto(String imgString) {
    return Center(
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              image:(imgString=="")?AssetImage('assets/img/placeholder.png'):NetworkImage(imgString),
              fit: BoxFit.cover),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (context.watch<LoginModel>().loggedIn) {
      return Consumer<ProfileModel>(builder: (context, model, child) {
        return FutureBuilder<DocumentSnapshot>(
            future: model
                .loadData(), // a previously-obtained Future<String> or null
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasData) {
                model.currentUser = snapshot.data;
                model.nameController.text = model.currentUser['name'];
                return Scaffold(
                  appBar: AppBar(
                    title: Text("Konto"),
                  ),
                  body: Container(
                      margin: EdgeInsets.all(15),
                      child: ListView(
                        children: [
                          _profilePhoto(snapshot.data['image']),
                          Container(
                              margin: EdgeInsets.only(bottom: 30),
                              child: Text(
                                snapshot.data['name'],
                                style: Theme.of(context).textTheme.headline4,
                                textAlign: TextAlign.center,
                              )),
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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            ItemList(
                                              showOwnedOnly: true,
                                            )));
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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
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
                              onTap: () => context.read<LoginModel>().logout(),
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
                return CircularProgressIndicator();
              }
            });
      });
    } else {
      return LoginScreen();
    }
  }
}
