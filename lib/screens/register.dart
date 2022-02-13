import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smakuwa/models/login_model.dart';
import 'package:smakuwa/models/register_model.dart';
import 'package:smakuwa/screens/login_screen.dart';
import 'package:provider/provider.dart';
class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterModel>(builder: (context, model, child) {
      return Scaffold(
          appBar: AppBar(
            title: Text('Zarejestruj się'),
          ),
          body: Padding(
              padding: EdgeInsets.all(10),
              child: Form(
                key: model.formKey,
                child: ListView(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextFormField(
                        controller: model.nameController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Pole jest puste!';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Imię wyświetlane w aplikacji',
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextFormField(
                        controller: model.emailController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Pole jest puste!';
                          } else if (model.emailUsed == true) {
                            model.emailUsed = false;
                            return 'Ten email już jest zarejestrowany';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextFormField(
                        obscureText: true,
                        controller: model.passwordController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Pole jest puste!';
                          } else if (model.passwordTooWeak == true) {
                            model.passwordTooWeak = false;
                            return 'Hasło jest zbyt słabe';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Hasło',
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextFormField(
                        obscureText: true,
                        controller: model.repeatPasswordController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Pole jest puste!';
                          } else if (text != model.passwordController.text) {
                            return 'Hasła się nie zgadzają!';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Powtórz hasło',
                        ),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 20),
                        height: 50,
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: ElevatedButton(
                          child: Text('Zarejestruj'),
                          onPressed: () {
                            if (model.formKey.currentState.validate()) {
                              model.register();
                              if (model.undefinedError) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: const Text(
                                        'Wystąpił problem z rejestracją'),
                                    content:
                                        const Text('Proszę spróbować później'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'OK'),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: const Text(
                                        'Poprawnie się zarejestrowano!'),
                                    content: const Text('Proszę się zalogować'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () => {
                                          Navigator.of(context).popUntil(
                                              (route) => route.isFirst),
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            }
                          },
                        )),
                  ],
                ),
              )));
    });
  }
}
