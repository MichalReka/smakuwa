import 'dart:ffi';
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
  DateTime selectedDate = DateTime.now();
  CollectionReference items = FirebaseFirestore.instance.collection('dishes');
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = File(pickedFile.path);
    } else {
      print('No image selected.');
    }
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

  Future<Uint8List> testCompressAndGetFile(File file) async {
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      quality: 50,
    );
    return result;
  }

  void addItem() async {
    try {
      await items.add({
        'name': nameController.text,
        'description': descriptionController.text,
        'date': selectedDate,
        'uid': FirebaseAuth.instance.currentUser.uid
      }).then((value) async {
        try {
          var ref = FirebaseStorage.instance.ref('dishes/' +
              FirebaseAuth.instance.currentUser.uid +
              "/" +
              value.id +
              "/" +
              "1");
          await ref.putData(await testCompressAndGetFile(image));
          var downloadUrlRef = await ref.getDownloadURL();
          await value
              .set({"image_url": downloadUrlRef}, SetOptions(merge: true));
          await File(image.path).delete();
        } on FirebaseException {
          print("Upload problem");
        }
      });
    } catch (e) {
      print(e);
      return;
    }
  }

  void uploadPhoto() {}
}
