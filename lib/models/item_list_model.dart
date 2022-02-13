import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smakuwa/models/document.dart';

class ItemListModel extends ChangeNotifier {
  static final tabs = ['dishes', 'products'];
  Map<String,List<Document>> items = {
    tabs[0]: [],
    tabs[1]: []
  };
  Map<String, ScrollController> scrollControllers = {
    tabs[0]: new ScrollController(),
    tabs[1]: new ScrollController()
  };

  Icon icon = new Icon(Icons.search, color: Colors.white);
  Widget title = new Text("Ryneczek");
  final _limitsIncrease = 2;
  Map<String, int> limits = {tabs[0]: 3, tabs[1]: 3};
  void _increaseLimit(String itemTab) {
    limits[itemTab] = limits[itemTab] + _limitsIncrease;
  }

  void setListener(String itemTab) {
    scrollControllers[itemTab].addListener(() {
      if (scrollControllers[itemTab].position.atEdge)
      {
        if(scrollControllers[itemTab].position.pixels!=0)
          {
            _increaseLimit(itemTab);
            notifyListeners();
          }
      }
    });
  }

  Stream itemListStream(bool ownedOnly, String itemsGroup, [String city = ""]) {
    var basicLimit = FirebaseFirestore.instance
        .collection(itemsGroup)
        .limit(limits[itemsGroup]);

    if (ownedOnly) {
      basicLimit.where('uid', isEqualTo: FirebaseAuth.instance.currentUser.uid);
    }

    if (city.isNotEmpty) {
      basicLimit.where('location', isEqualTo: city);
    }

    return basicLimit.snapshots();
  }
}
