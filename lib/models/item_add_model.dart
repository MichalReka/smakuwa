import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ItemAddModel{
  File image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        image=File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    }
  }
