import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:smakuwa/models/login_model.dart';
import 'package:smakuwa/screens/item_add.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import 'chat_page.dart';
import 'login_screen.dart';

class FoodDetails extends StatelessWidget {
  final document;
  final tag;
  FoodDetails(this.tag, this.document);
  Widget _displayImage(String uri, BuildContext context) {
    if (uri.isEmpty) {
      return Image.asset(
        "assets/img/product-placeholder.jpg",
        fit: BoxFit.cover,
        height: MediaQuery.of(context).size.height * 0.35,
        width: MediaQuery.of(context).size.width,
      );
    } else {
      return FadeInImage(
        fit: BoxFit.cover,
        height: MediaQuery.of(context).size.height * 0.35,
        width: MediaQuery.of(context).size.width,
        image: NetworkImage(
          uri,
        ),
        placeholder: MemoryImage(kTransparentImage),
      );
    }
  }

  Widget _displayUserImage(String uri) {
    return Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: new DecorationImage(
              fit: BoxFit.cover,
              image: (uri == "")
                  ? AssetImage("assets/img/placeholder.png")
                  : NetworkImage(uri))),
    );
  }
  void _handleSendMessage(BuildContext context) async
  {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection("users").doc(document['uid']).get();
    types.User user = types.User.fromJson({"createdAt":snapshot['createdAt'].millisecondsSinceEpoch,"firstName":snapshot['firstName'],"id":document['uid'],'imageUrl':snapshot['imageUrl']});
    final room = await FirebaseChatCore.instance.createRoom(user);
    Navigator.of(context).pop();
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatPage(
          room: room,
        ),
      ),
    );
  }
  Widget _buttons(bool owner, BuildContext context) {
    if (owner) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(),
          ElevatedButton(
            child: Text("Edytuj"),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ItemAdd(editMode: true,editedItem: document,)));
            },
          ),
          ElevatedButton(
            child: Text("Usuń"),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                  AlertDialog(
                    title: const Text(
                        'Czy na pewno chcesz usunąć ogłoszenie?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => {
              document.reference.delete(),
              Navigator.of(context).popUntil(
                                  (route) => route.isFirst),
                        },
                        child: const Text('Tak'),
                      ),
                      TextButton(
                        onPressed: () => {
                          Navigator.of(context).pop(),
                        },
                        child: const Text('Nie'),
                      ),
                    ],
                  ));
            },
          ),
          SizedBox(),
        ],
      );
    } else {
      return Center(child: ElevatedButton(child: Text("Wyślij wiadomość"), onPressed: () {
        if(!Provider.of<LoginModel>(context, listen: false).loggedIn)
          {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LoginScreen()),
            );
          }
        else
          {
            _handleSendMessage(context);
          }
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    bool owner = false;
    var margin = EdgeInsets.only(left: 8);
    if (context.watch<LoginModel>().loggedIn) {
      if (document['uid'] == FirebaseAuth.instance.currentUser.uid) {
        owner = true;
      }
    }
    return Container(
        color: Colors.white,
        child: ListView(children: [
          Hero(
              tag: tag,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: _displayImage(document["image_url"], context)),
              )),
/*            Text("Data dodania: "+)*/

          Container(
              margin: margin,
              child: Text(
                document["name"],
                style: Theme.of(context).textTheme.headline4,
              )),
          Container(
              margin: margin,
              child: Text(
                "Opis:",
                style: Theme.of(context).textTheme.headline6,
              )),
          Container(
              margin: margin,
              child: Text(
                document["description"],
                style: Theme.of(context).textTheme.bodyText2,
              )),
          Container(
              margin: margin,
              child: Text(
                "Miejscowość:",
                style: Theme.of(context).textTheme.headline6,
              )),
          Container(
              margin: margin,
              child: Text(
                document["location"],
                style: Theme.of(context).textTheme.bodyText2,
              )),
          Container(
              margin: margin,
              child: Text(
                "Data dodania:",
                style: Theme.of(context).textTheme.headline6,
              )),
          Container(
            margin: margin,
            child: Text(
              DateFormat('dd-MM-yyyy')
                  .format(DateTime.parse(
                      document["added_date"].toDate().toString()))
                  .toString(),
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
          Container(
              margin: margin,
              child: Text(
                "Data ważności:",
                style: Theme.of(context).textTheme.headline6,
              )),
          Container(
            margin: margin,
            child: Text(
              DateFormat('dd-MM-yyyy')
                  .format(DateTime.parse(
                      document["expiration_date"].toDate().toString()))
                  .toString(),
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
          Container(
              margin: margin,
              child: Text(
                "Wegetariańskie",
                style: Theme.of(context).textTheme.headline6,
              )),
          Container(
              margin: margin,
              child: Text(
                (document["vege"]) ? "Tak" : "Nie",
                style: Theme.of(context).textTheme.bodyText2,
              )),
          Divider(
            thickness: 2,
            height: 30,
          ),
          FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection("users")
                  .doc(document['uid'])
                  .get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _displayUserImage(snapshot.data['imageUrl']),
                          Text(
                            snapshot.data['firstName'],
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ],
                      ),
                      _buttons(owner, context)
                    ],
                  );
                } else {
                  return CircularProgressIndicator();
                }
              }),
        ]));
  }
}
