import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:smakuwa/models/login_model.dart';
import 'package:smakuwa/screens/item_add.dart';
import 'package:provider/provider.dart';
import 'package:smakuwa/screens/login_screen.dart';
import 'item_details.dart';

class ItemList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Potrawy"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("dishes").snapshots(),
        builder: (context, snapshot) {
          return Container(
            child: ListView.builder(
                itemCount: snapshot.data == null ? 0 : snapshot.data.docs.length,
                itemBuilder: (context, index) {
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
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(15)),
                            child: Hero(
                              tag: currentDoc.id,
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => FoodDetails(currentDoc.id,currentDoc)),
                                      );
                                    },
                                    child: Image.network(
                                        currentDoc["image_url"],
                                        height: 150,
                                        fit: BoxFit.cover)),
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
        }
      ),
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
