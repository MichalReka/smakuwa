import 'package:flutter/material.dart';

class AccountModel extends ChangeNotifier{
  editImage()
  {

  }
  changeData()
  {

  }
  Widget _profilePhoto(AccountModel model) {
    return Center(
      child: InkWell(
        onTap: model.editImage,
        child: Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                image: AssetImage('assets/img/placeholder.png'),
                fit: BoxFit.fill),
          ),
        ),
      ),
    );
  }
}