import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:provider/provider.dart';
import 'package:smakuwa/models/login_model.dart';
import 'package:smakuwa/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'chat_page.dart';
import 'users.dart';

class RoomList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if(context.watch<LoginModel>().loggedIn)
      {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Wiadomości'),
          ),
          body: StreamBuilder<List<types.Room>>(
            stream: FirebaseChatCore.instance.rooms(),
            initialData: const [],
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data.isEmpty) {
                return Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(
                    bottom: 200,
                  ),
                  child: const Text('Nie ma żadnych wiadomości'),
                );
              }

              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  final room = snapshot.data[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            room: room,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 80,
                            margin: const EdgeInsets.only(
                              right: 16,
                            ),
                            width: 80,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(90),
                              ),
                              child: Image(
                                image:   (room.imageUrl=="") ? AssetImage("assets/img/placeholder.png")
                                    : NetworkImage(room.imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Text(room.name, style: Theme.of(context).textTheme.headline6,),

                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      }
    else
      {
        return LoginScreen();
      }
  }
}
