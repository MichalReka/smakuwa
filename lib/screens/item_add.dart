import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:smakuwa/models/item_add_model.dart';
import 'package:smakuwa/models/json_models.dart';
import 'package:smakuwa/models/login_model.dart';
import 'package:smakuwa/screens/login_screen.dart';
import 'package:smakuwa/screens/process_screen.dart';

class ItemAdd extends StatelessWidget {
  final _imageHeight = 0.25;
  final bool editMode;
  final DocumentSnapshot editedItem;

  const ItemAdd({Key key, this.editedItem, this.editMode = false})
      : super(key: key);
  Widget _displayImage(BuildContext context, ItemAddModel model) {
    if (model.image != null) {
      return TextButton(
          onPressed: () => model.getImage(),
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * _imageHeight,
            child: Image.file(model.image, fit: BoxFit.cover),
          ));
    }
    if (editMode) {
      if (editedItem['image_url'] != '') {
        return TextButton(
            onPressed: () => model.getImage(),
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * _imageHeight,
              child: Image.network(editedItem['image_url'], fit: BoxFit.cover),
            ));
      }
    }
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

  static String _displayStringForOption(City city) => city.text;
  Future<String> readJson(BuildContext context) {
    return DefaultAssetBundle.of(context)
        .loadString("assets/cities/search_index.json");
  }

  List<City> createCities(List<Regions> regions) {
    List<City> outputCities = [];
    for (var region in regions) {
      for (var city in region.cities) {
        outputCities.add(city);
      }
    }
    outputCities.sort((a, b) {
      return a.text.compareTo(b.text);
    });
    return outputCities;
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
          return FutureBuilder(
              future: readJson(context),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final regions = regionsFromJson(snapshot.data);
                  model.citiesList = createCities(regions);
                  if (editMode == true) {
                    model.loadData(editedItem);
                  }
                  return Form(
                    key: model.formKey,
                    child: Container(
                      margin: EdgeInsets.all(15),
                      child: ListView(
                        children: <Widget>[
                          _displayImage(context, model),
                          Autocomplete<City>(
                            fieldViewBuilder: (BuildContext context,
                                TextEditingController
                                    fieldTextEditingController,
                                FocusNode fieldFocusNode,
                                VoidCallback onFieldSubmitted) {
                              fieldTextEditingController.text =
                                  model.cityController.text;
                              return Container(
                                margin: EdgeInsets.only(bottom: 10),
                                child: TextFormField(
                                  // The validator receives the text that the user has entered.
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Pole nie może być puste';
                                    } else if (model.selectedCity == null ||
                                        model.selectedCity.text != value) {
                                      return 'Proszę wybrać miasto z listy';
                                    }
                                    return null;
                                  },
                                  focusNode: fieldFocusNode,
                                  controller: fieldTextEditingController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Wpisz miasto i wybierz z listy',
                                  ),
                                ),
                              );
                            },
                            displayStringForOption: _displayStringForOption,
                            optionsBuilder:
                                (TextEditingValue textEditingValue) {
                              if (textEditingValue.text == '') {
                                return const Iterable<City>.empty();
                              }
                              return model.citiesList.where((City option) {
                                return option
                                    .toString()
                                    .toLowerCase()
                                    .startsWith(
                                        textEditingValue.text.toLowerCase());
                              });
                            },
                            onSelected: (City selection) {
                              model.selectedCity = selection;
                            },
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: TextFormField(
                              // The validator receives the text that the user has entered.
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Pole nie może być puste';
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
                                return 'Pole nie może być puste';
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
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.transparent),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Theme.of(context).textTheme.bodyText1.color),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text("Data ważności"),
                                Text("${model.selectedDate.toLocal()}"
                                    .split(' ')[0]),
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
                                  if (editMode) {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                ProcessScreen(
                                                    futureOperation:
                                                        model.editItem,
                                                    onEnd: "Edycja ukończona!",
                                                    onError:
                                                        "Edycja nie powiodła się, spróbuj ponownie później",
                                                    process: "Edycja...")));
                                  } else {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                ProcessScreen(
                                                    futureOperation:
                                                        model.addItem,
                                                    onEnd:
                                                        "Dodawanie ukończone!",
                                                    onError:
                                                        "Dodawanie nie powiodło się, spróbuj ponownie później",
                                                    process: "Dodawanie...")));
                                  }
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
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              });
        }),
      );
    } else {
      return LoginScreen();
    }
    // Build a Form widget using the _formKey created above.
  }
}
