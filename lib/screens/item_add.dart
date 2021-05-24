import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:smakuwa/models/item_add_model.dart';
import 'package:smakuwa/models/login_model.dart';
import 'package:smakuwa/screens/login_screen.dart';

class ItemAdd extends StatelessWidget {
  final _imageHeight = 0.25;

  Widget _displayImage(BuildContext context, ItemAddModel model) {
    if (model.image != null) {
      return TextButton(
          onPressed: () => model.getImage(),
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * _imageHeight,
            child: Image.file(model.image, fit: BoxFit.cover),
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
    if (context.watch<LoginModel>().loggedIn) {
      return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("Wystaw jedzenie"),
        ),
        body: Consumer<ItemAddModel>(builder: (context, model, child) {
          return Form(
            key: model.formKey,
            child: Container(
              margin: EdgeInsets.all(15),
              child: ListView(
                children: <Widget>[
                  _displayImage(context, model),
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
                  OutlinedButton(
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
                  DropdownButtonFormField<String>(
                    value: model.selectedItem,
                    onChanged: (String newValue) {
                      model.setSelectedItem(newValue);
                    },
                    items: model.dropdownItems
                        .map((key, value) {
                          return MapEntry(
                              value,
                              DropdownMenuItem<String>(
                                value: key,
                                child: Text(value),
                              ));
                        })
                        .values
                        .toList(),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (model.formKey.currentState.validate()) {
/*                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Dodawanie...')));*/
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      AddingProcessScreen()));

/*                            model.addItem();
                            model.formKey.currentState.reset();*/
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
    } else {
      return LoginScreen();
    }
    // Build a Form widget using the _formKey created above.
  }
}

class AddingProcessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ItemAddModel>(
        builder: (context, model, child) {
          return FutureBuilder(
              future: model.addItem(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data == true) {
                    return Container(
                      width: MediaQuery.of(context).size.width,

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Dodawanie ukończone!",
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          Icon(
                            Icons.done_rounded,
                            color: Colors.green,
                            size: 70
                          ),
                          ElevatedButton(onPressed: (){
                            Navigator.pop(context);
                          }, child: Text("Wróć"))
                        ],
                      ),
                    );
                  } else {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Nie udało się dodać!",
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            Icon(
                              Icons.close_rounded,
                              color: Colors.red,
                              size: 80,
                            )
                          ]),
                    );
                  }
                } else {
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Dodawanie...",
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        CircularProgressIndicator()
                      ]);
                }
              });
        },
      ),
    );
  }
}
