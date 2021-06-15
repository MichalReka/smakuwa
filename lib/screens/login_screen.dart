import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smakuwa/models/item_add_model.dart';
import 'package:smakuwa/models/login_model.dart';
import 'package:smakuwa/screens/register.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginModel>(builder: (context, model, child) {
      return Scaffold(
          appBar: AppBar(
            title: Text('Zaloguj się'),
          ),
          body: Padding(
              padding: EdgeInsets.all(10),
              child: ListView(
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Logo',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 30),
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
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextField(
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
                      //forgot password screen
                    },
                    child: Text('Zapomniałem/am hasła'),
                  ),
                  Container(
                      height: 50,
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton(
                        child: Text('Login'),
                        onPressed: () {
                          model.signIn();
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
                            MaterialPageRoute(builder: (context) => RegisterScreen()),
                          );
                        },
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ))
                ],
              )));
    });
  }
}
