import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:smakuwa/models/item_add_model.dart';

class ItemAdd extends StatefulWidget {
  @override
  ItemAddState createState() {
    return ItemAddState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class ItemAddState extends State<ItemAdd> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  DateTime selectedDate = DateTime.now();
  final _imageHeight = 0.25;
  final _formKey = GlobalKey<FormState>();
  final _itemAddModel = new ItemAddModel();
  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
    return null;
  }
  Widget _displayImage(){
    if(_itemAddModel.image!=null)
      {
        return TextButton(onPressed: ()=>_itemAddModel.getImage(),child: Image.file(_itemAddModel.image,height: MediaQuery.of(context).size.height*_imageHeight,fit: BoxFit.contain));
      }
    else
      {
        return TextButton(onPressed: ()=>_itemAddModel.getImage(), child: Container(
          alignment: Alignment.center,
          color: Colors.black38,
          height: MediaQuery.of(context).size.height*_imageHeight,
          child: Text(
            "Wybierz zdjęcie", style: Theme.of(context).textTheme.bodyText1,
          ),
        ));
      }
  }
  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Wystaw jedzenie"),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _displayImage(),
              Text("Nazwa potrawy"),
              TextFormField(
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              Text("Wybierz datę ważności"),
              TextButton(
                onPressed: () => _selectDate(context),
                // The validator receives the text that the user has entered.
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                  foregroundColor: MaterialStateProperty.all<Color>(Theme.of(context).textTheme.bodyText1.color),
                ),
                child: Text(
                    "${selectedDate.toLocal()}".split(' ')[0]
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
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('Processing Data')));
                    }
                  },
                  child: Text('Wystaw'),

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}