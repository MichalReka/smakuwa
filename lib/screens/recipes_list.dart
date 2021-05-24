import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:smakuwa/custom_icons/custom-icons.dart';
import 'package:smakuwa/models/item_list_model.dart';
import 'package:smakuwa/models/login_model.dart';
import 'package:smakuwa/screens/item_add.dart';
import 'package:provider/provider.dart';
import 'package:smakuwa/screens/login_screen.dart';
import 'package:transparent_image/transparent_image.dart';
import 'item_details.dart';

//TODO: OPTYMALIZACJA READ/WRITE POPRZEZ LIMIT WYSWIETLANYCH DOKUMENTOW - SUBSET NIE CALOSC (NIE 1-5 tylko 1-3, 3-5) - czyli kazdy dokument to klasa
class RecipesList extends StatelessWidget {
  Widget _displayImage(String uri) {
    print(uri);
    if (uri.isEmpty) {
      return Image.asset(
        "assets/img/product-placeholder.jpg",
        fit: BoxFit.cover,
        height: 150,
      );
    } else {
      return FadeInImage(
        fit: BoxFit.cover,
        height: 150,
        image: NetworkImage(
          uri,
        ),
        placeholder: MemoryImage(kTransparentImage),
      );
    }
  }

  Widget _displayItemList(BuildContext context, String itemsGroup) {
    return Consumer<ItemListModel>(builder: (context, model, child) {
      return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(itemsGroup)
              .limit(model.limits[itemsGroup])
              .snapshots(),
          builder: (context, snapshot) {
            return Container(
              child: ListView.builder(
                  controller: model.scrollControllers[itemsGroup],
                  itemCount:
                  snapshot.data == null ? 0 : snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    model.setListener(itemsGroup);
                    DocumentSnapshot currentDoc = snapshot.data.docs[index];
                    return Card(
                        margin: EdgeInsets.all(10.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        elevation: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(15)),
                              child: Hero(
                                tag: currentDoc.id,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => FoodDetails(
                                                  currentDoc.id, currentDoc)),
                                        );
                                      },
                                      child: _displayImage(
                                          currentDoc['image_url'])),
                                ),
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.all(10),
                                child: Text(
                                  currentDoc["name"],
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.headline6,
                                ))
                          ],
                        ));
                  }),
            );
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
          title: Text("Przepisy"),

      ),
      body: _displayItemList(context, "dishes"),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ItemAdd()),
          );
        },
        tooltip: 'Dodaj potrawę',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
