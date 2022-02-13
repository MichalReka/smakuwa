import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:smakuwa/models/password_reset_model.dart';
import 'package:smakuwa/screens/process_screen.dart';

class PasswordReset extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PasswordResetModel>(builder: (context, model, child) {
      return Scaffold(
          appBar: AppBar(
            title: Text('Przywracanie hasła'),
          ),
          body: Padding(
              padding: EdgeInsets.all(10),
              child: ListView(
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10),
                      child: Image(
                        image: AssetImage("assets/img/icon.png"),
                      )),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      controller: model.emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                    ),
                  ),
                  Container(
                      height: 50,
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton(
                          child: Text('Zapomniałem/am hasła'),
                          onPressed: () {
                            Navigator.of(context).pushReplacement(MaterialPageRoute(
                                builder: (BuildContext context) => ProcessScreen(
                                    futureOperation: model.passwordReset,
                                    onEnd: "Wysłano haslo na mail",
                                    onError:
                                        "Wysyłanie nie powiodło się, spróbuj ponownie później",
                                    process: "Wysyłanie...")));
                          })),
                ],
              )));
    });
  }
}
