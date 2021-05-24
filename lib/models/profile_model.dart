import 'package:flutter/material.dart';

class ProfileModel extends ChangeNotifier{
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  bool editImage = false;

  changeData()
  {

  }
  loadData()
  {

  }

  switchImageModes() {
    editImage = !editImage;
    notifyListeners();
  }
}