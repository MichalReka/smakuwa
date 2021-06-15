import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smakuwa/models/profile_model.dart';
import 'package:smakuwa/models/login_model.dart';
import 'package:provider/provider.dart';
import 'package:smakuwa/screens/process_screen.dart';

import 'login_screen.dart';
//TODO: ZMNIEJSZYC ILOSC WCZYTYWANIA DANYCH O USERZE - WCZYTYWANE SA DWA RAZY
class ProfileEdit extends StatelessWidget {
  Widget _profilePhoto(BuildContext context, ProfileModel model) {
    ImageProvider image = (model.currentUser['image'] == "")
        ? AssetImage("assets/img/placeholder.png")
        : NetworkImage(model.currentUser['image']);
    return Center(
      child: Material(
        child: Ink(
          width: 250,
          height: 250,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                image: model.image != null ? FileImage(model.image) : image,
                fit: BoxFit.cover),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(180),
            onTap: () => model.getImage(),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding: EdgeInsets.all(17),
                decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.circular(100)),
                child: Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (context.watch<LoginModel>().loggedIn) {
      return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("Edytuj Profil"),
        ),
        body: Consumer<ProfileModel>(builder: (context, model, child) {
          return FutureBuilder<DocumentSnapshot>(
              future: model
                  .loadData(), // a previously-obtained Future<String> or null
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData) {
                  model.currentUser=snapshot.data;
                  model.nameController.text=model.currentUser['name'];
                  return Form(
                    key: model.formKey,
                    child: Container(
                      margin: EdgeInsets.all(15),
                      child: ListView(
                        children: <Widget>[
                          _profilePhoto(context, model),
                          Divider(),
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: TextFormField(
                              // The validator receives the text that the user has entered.
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              controller: model.nameController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Imię wyświetlane w smakuwie',
                              ),
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: ElevatedButton(
                              onPressed: () {
                                // Validate returns true if the form is valid, or false otherwise.
                                if (model.formKey.currentState.validate()) {
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ProcessScreen(
                                              futureOperation:  model.changeData,
                                              onEnd: "Edycja ukończona!",
                                              onError:
                                              "Edycja nie powiodła się, spróbuj ponownie później",
                                              process: "Edycja...")));
                                }
                              },
                              child: Text('Zapisz'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              });
        }),
      );
    } else {
      return LoginScreen();
    }
  }
}
