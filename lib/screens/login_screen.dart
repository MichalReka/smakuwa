import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smakuwa/models/item_add_model.dart';
import 'package:smakuwa/models/login_model.dart';
import 'package:smakuwa/screens/password_recover.dart';
import 'package:smakuwa/screens/register.dart';

class LoginScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return Consumer<LoginModel>(builder: (context, model, child) {
      return Scaffold(
          appBar: AppBar(
            title: Text('Zaloguj się'),
          ),
          body: Padding(
              padding: EdgeInsets.all(10),
              child: Form(
                key: formKey,
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
                      child: TextFormField(
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            print("empty");
                            return 'Pole jest puste!';
                          } else if (model.noEmailFound) {
                            model.noEmailFound = false;

                            return 'Nie znaleziono użytkownika!';
                          }
                          return null;
                        },
                        controller: model.emailController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextFormField(
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Pole jest puste!';
                          } else if (model.wrongPassword) {
                            model.wrongPassword = false;
                            return 'Złe hasło!';
                          }
                          return null;
                        },
                        obscureText: true,
                        controller: model.passwordController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Hasło',
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PasswordReset()),
                        );
                      },
                      child: Text('Zapomniałem/am hasła'),
                    ),
                    Container(
                        height: 50,
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: ElevatedButton(
                          child: Text('Login'),
                          onPressed: () {
                            if (formKey.currentState.validate()) {
                              model.signIn();
                            }
                          },
                        )),
                    Container(
                        child: Row(
                      children: <Widget>[
                        Text('Czy masz konto?'),
                        TextButton(
                          child: Text(
                            'Zarejestruj się',
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterScreen()),
                            );
                          },
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ))
                  ],
                ),
              )));
    });
  }
}
