import 'package:flutter/material.dart';
import 'package:smakuwa/screens/item_add.dart';

import 'item_details.dart';

class ItemList extends StatelessWidget {
  final dishes = ['pizza', 'sałatka', 'kanapki', 'pizza', 'sałatka', 'kanapki'];
  final dishesImg = [
    'pizza.jpg',
    'salad.jpg',
    'sandwich.jpg',
    'pizza.jpg',
    'salad.jpg',
    'sandwich.jpg'
  ];
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Lokacja"),
      ),
      body: Container(
        child: ListView.builder(
            itemCount: dishes.length,
            itemBuilder: (context, index) {
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
                          tag: index,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FoodDetails(index,"assets/img/" + dishesImg[index])),
                                  );
                                },
                                child: Image.asset(
                                    "assets/img/" + dishesImg[index],
                                    height: 150,
                                    fit: BoxFit.cover)),
                          ),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.all(10),
                          child: Text(
                            dishes[index],
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline6,
                          ))
                    ],
                  ));
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ItemAdd()),
          );
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}