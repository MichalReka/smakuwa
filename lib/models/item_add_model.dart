import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

class ItemAddModel with ChangeNotifier {
  File image;
  final picker = ImagePicker();
  final formKey = GlobalKey<FormState>();

  DateTime selectedDate = DateTime.now();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String selectedItem = "dishes";
  CollectionReference items = FirebaseFirestore.instance.collection('dishes');
  Map<dynamic,dynamic> dropdownItems = {"dishes":"Potrawy","products":"Produkty"};
  bool itemAdded = false;
  bool _imageSelected = false;



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

  setSelectedItem(String value)
  {
    selectedItem=value;
    items = FirebaseFirestore.instance.collection(value);
    notifyListeners();
  }

  Future selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
    }
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
        'location':'Miasto',
        'vege':true,
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
                  .set({"image_url": downloadUrlRef}, SetOptions(merge: true));
            }
          else
            {
              await value
                  .set({"image_url": ""}, SetOptions(merge: true));
            }
          added = true;
          _imageSelected = false;
          image = null;
          nameController.text="";
          descriptionController.text="";
        } on FirebaseException {
          print("Upload problem");
        }
      });
    } catch (e) {
      print(e);
    }
    return added;
  }

}
