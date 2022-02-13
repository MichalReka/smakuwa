import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

class ProfileModel extends ChangeNotifier{
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  ImagePicker picker = new ImagePicker();
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  DocumentSnapshot currentUser;
  File image;
  bool _imageSelected = false;
  bool userLoaded = false;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      _imageSelected=true;
      notifyListeners();
    } else {
      print('No image selected.');
    }
  }
  Future<Uint8List> compressAndGetFile(File file) async {
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      quality: 45,
    );
    return result;
  }
  Future changeData() async{
    var docRef = users.doc(FirebaseAuth.instance.currentUser.uid);
    var storageRef = FirebaseStorage.instance.ref('users/' +
        FirebaseAuth.instance.currentUser.uid);
    if(_imageSelected)
    {
      await storageRef.putData(await compressAndGetFile(image));
    var downloadUrlRef = await storageRef.getDownloadURL();
    await docRef
        .set({"imageUrl": downloadUrlRef}, SetOptions(merge: true));
    }
    await docRef
        .set({"firstName": nameController.text}, SetOptions(merge: true));
    _imageSelected = false;
    image = null;
    nameController.clear();
    notifyListeners();
    return true;
  }
  Future<DocumentSnapshot> loadData() async
  {
    return users.doc(FirebaseAuth.instance.currentUser.uid).get();
  }
}