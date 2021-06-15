/// Flutter code sample for Autocomplete

// This example shows how to create an Autocomplete widget with a custom type.
// Try searching with text from the name or email field.

import 'package:flutter/material.dart';
import 'package:smakuwa/models/json_models.dart';

class AutocompleteExampleApp extends StatelessWidget {
  const AutocompleteExampleApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Autocomplete Basic User'),
        ),
        body: const Center(
          child: AutocompleteBasicUserExample(),
        ),
      );
  }
}

class AutocompleteBasicUserExample extends StatelessWidget {
  const AutocompleteBasicUserExample({Key key}) : super(key: key);
  static String _displayStringForOption(City city) => city.text;
  Future<String> readJson(BuildContext context){
    return DefaultAssetBundle.of(context).loadString("assets/cities/search_index.json");
}
  List<City> createCities(List<Regions> regions)
  {
    List<City> outputCities = [];
    for(var region in regions)
      {
        for(var city in region.cities)
          {
            outputCities.add(city);
          }
      }
    outputCities.sort((a,b) {
      return a.text.compareTo(b.text);
    });
    return outputCities;
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: readJson(context), // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if(snapshot.hasData)
            {
              final regions = regionsFromJson(snapshot.data);
              final cities = createCities(regions);
              return Autocomplete<City>(
                displayStringForOption: _displayStringForOption,
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') {
                    return const Iterable<City>.empty();
                  }
                  return cities.where((City option) {
                    return option
                        .toString().toLowerCase()
                        .startsWith(textEditingValue.text.toLowerCase());
                  });
                },
                onSelected: (City selection) {
                  print('You just selected ${_displayStringForOption(selection)}');
                },
              );
            }
          else
            {
              return CircularProgressIndicator();
            }
        }
    );
  }
}