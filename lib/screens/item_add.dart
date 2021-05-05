import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:smakuwa/models/item_add_model.dart';
import 'package:smakuwa/models/login_model.dart';
import 'package:smakuwa/screens/login_screen.dart';

class ItemAdd extends StatelessWidget {
  final _imageHeight = 0.25;
  final _formKey = GlobalKey<FormState>();

  Widget _displayImage(BuildContext context, ItemAddModel model) {
    if (model.image != null) {
      return TextButton(
          onPressed: () => model.getImage(),
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * _imageHeight,
            child: Image.file(model.image,
                fit: BoxFit.cover),
          ));
    } else {
      return TextButton(
          onPressed: () => model.getImage(),
          child: Container(
            alignment: Alignment.center,
            color: Colors.black38,
            height: MediaQuery.of(context).size.height * _imageHeight,
            child: Text(
              "Wybierz zdjęcie",
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    if(context.watch<LoginModel>().loggedIn)
      {
        return Scaffold(
          appBar: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Text("Wystaw jedzenie"),
          ),
          body: Consumer<ItemAddModel>(builder: (context, model, child) {
            return Form(
              key: _formKey,
              child: Container(
                margin: EdgeInsets.all(15),
                child: ListView(
                  children: <Widget>[
                    _displayImage(context,model),
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
                          border: UnderlineInputBorder(),
                          labelText: 'Nazwa potrawy',
                        ),
                      ),
                    ),
                    TextFormField(

                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      controller: model.descriptionController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Opis potrawy (przepis, składniki)',
                      ),
                      minLines: 5,
                      maxLines: 10,
                    ),
                    TextButton(
                      onPressed: () => model.selectDate(context),
                      // The validator receives the text that the user has entered.
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.transparent),
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).textTheme.bodyText1.color),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Data ważności"),
                          Text("${model.selectedDate.toLocal()}".split(' ')[0]),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // Validate returns true if the form is valid, or false otherwise.
                          if (_formKey.currentState.validate()) {
                            // If the form is valid, display a snackbar. In the real world,
                            // you'd often call a server or save the information in a database.
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Dodawanie...')));
                            model.addItem();
                          }
                        },
                        child: Text('Wystaw'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      }
    else
      {
        return LoginScreen();
      }
    // Build a Form widget using the _formKey created above.

  }
}
