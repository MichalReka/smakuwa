import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileModel extends ChangeNotifier{
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  ImagePicker picker = new ImagePicker();
  File image;
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      notifyListeners();
    } else {
      print('No image selected.');
    }

  }
  changeData()
  {

  }
  loadData()
  {

  }

}