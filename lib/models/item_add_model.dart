import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

import 'json_models.dart';

class ItemAddModel with ChangeNotifier {

  File image;
  final picker = ImagePicker();
  final formKey = GlobalKey<FormState>();

  DateTime selectedDate = DateTime.now();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  String selectedItem = "dishes";
  CollectionReference items = FirebaseFirestore.instance.collection('dishes');
  Map<dynamic,dynamic> dropdownItems = {"dishes":"Potrawy","products":"Produkty"};
  City selectedCity;
  bool itemAdded = false;
  bool _imageSelected = false;
  bool editMode = false;
  bool _editing = false;
  List<City> citiesList;
  DocumentReference editedDocument;
  String _imageUrl;
    loadData(DocumentSnapshot itemDetails){
    nameController.text=itemDetails["name"];
    descriptionController.text=itemDetails["description"];
    selectedDate = DateTime.fromMillisecondsSinceEpoch(itemDetails['added_date'].millisecondsSinceEpoch);
    selectedItem = itemDetails.reference.parent.id;
    selectedCity = citiesList.singleWhere((City option) {
      return itemDetails["location"]
          .toString().contains(option.textSimple);
    });
    print(selectedCity.textSimple);
    cityController.text = selectedCity.text;
    _imageUrl = itemDetails['image_url'];
    editedDocument=itemDetails.reference;
    _editing=true;
  }
  void selectCity(City selected){
      selectedCity=selected;
      cityController.text=selected.text;
      notifyListeners();
  }
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      notifyListeners();
      _imageSelected = true;
    } else {
      print('No image selected.');
    }
  }

  void _clear()
  {
    _imageSelected = false;
    image = null;
    nameController.text="";
    descriptionController.text="";
    selectedCity = null;
    editedDocument = null;
    _imageUrl="";
    cityController.text="";
  }

  setSelectedItem(String value)
  {
    selectedItem = value;
    items = FirebaseFirestore.instance.collection(value);
    notifyListeners();
  }

  Future selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: (DateTime.now().millisecondsSinceEpoch>selectedDate.millisecondsSinceEpoch)?selectedDate:DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null) {
      selectedDate = picked;
    }
    print(selectedDate);
    notifyListeners();
    return null;
  }

  Future<Uint8List> compressAndGetFile(File file) async {
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      quality: 35,
    );
    return result;
  }

  Future<bool> addItem() async {
    var added=false;
    try {
      await items.add({
        'name': nameController.text,
        'description': descriptionController.text,
        'added_date': DateTime.now(),
        'expiration_date': selectedDate,
        'uid': FirebaseAuth.instance.currentUser.uid,
        'location':selectedCity.text,
        'vege':true,
        'image_url':""
      }).then((value) async {
        try {
          var ref = FirebaseStorage.instance.ref('dishes/' +
              FirebaseAuth.instance.currentUser.uid +
              "/" +
              value.id +
              "/" +
              "1");
          if(_imageSelected)
            {
              await ref.putData(await compressAndGetFile(image));
              var downloadUrlRef = await ref.getDownloadURL();
              await value
                  .update({"image_url": downloadUrlRef});
            }
          else
            {
              await value
                  .update({"image_url": ""});
            }
          added = true;
          _clear();
        } on FirebaseException {
          print("Upload problem");
        }
      });
    } catch (e) {
      print(e);
    }
    return added;
  }
  Future<bool> editItem() async {
    var edited=false;
    try {
      await editedDocument.update({
        'name': nameController.text,
        'description': descriptionController.text,
        'added_date': DateTime.now(),
        'expiration_date': selectedDate,
        'uid': FirebaseAuth.instance.currentUser.uid,
        'location':selectedCity.text,
        'vege':true,
        'image_url':_imageUrl
      }).then((value) async {
        try {
          var ref = FirebaseStorage.instance.ref('dishes/' +
              FirebaseAuth.instance.currentUser.uid +
              "/" +
              editedDocument.id +
              "/" +
              "1");
          if(_imageSelected)
          {
            await ref.putData(await compressAndGetFile(image));
            var downloadUrlRef = await ref.getDownloadURL();
            await editedDocument
                .set({"image_url": downloadUrlRef}, SetOptions(merge: true));
          }
          edited = true;
          _clear();
        } on FirebaseException {
          print("Upload problem");
        }
      });
    } catch (e) {
      print(e);
    }
    return edited;
  }
}
