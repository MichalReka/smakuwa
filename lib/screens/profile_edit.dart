import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smakuwa/models/profile_model.dart';
import 'package:smakuwa/models/login_model.dart';
import 'package:provider/provider.dart';

import 'login_screen.dart';
class ProfileEdit extends StatelessWidget {

  Widget _profilePhoto(BuildContext context,ProfileModel model) {

        return Center(
          child: Material(
            child: Ink(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: model.image!=null ? FileImage(model.image):AssetImage('assets/img/placeholder.png'),
                    fit: BoxFit.cover),
              ),
              child: InkWell(
                  borderRadius: BorderRadius.circular(180),
                  onTap: ()=>model.getImage(),
                child: Align(
                alignment: Alignment.bottomRight,

                child: Container(
                  padding: EdgeInsets.all(17),
                  decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      borderRadius:BorderRadius.circular(100)
                  ),
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
      context.watch<ProfileModel>().loadData();  //ONLY ONCE
      return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("Edytuj Profil"),
        ),
        body: Consumer<ProfileModel>(builder: (context, model, child) {
          return Form(
            key: model.formKey,
            child: Container(
              margin: EdgeInsets.all(15),
              child: ListView(
                children: <Widget>[
                  _profilePhoto(context,model),
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
/*                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Dodawanie...')));*/
/*                            model.addItem();
                            model.formKey.currentState.reset();*/
                        }
                      },
                      child: Text('Zapisz'),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      );
    } else {
      return LoginScreen();
    }
  }
}
