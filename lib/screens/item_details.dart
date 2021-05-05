import 'package:flutter/material.dart';

class FoodDetails extends StatelessWidget {
  final document;
  final tag;
  FoodDetails(this.tag,this.document);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
        child: ListView(
          children: [Hero(
            tag: tag,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                  onTap: () {
                    Navigator.pop(
                      context
                    );
                  },
                  child: Image.network(
                      document["image_url"],
                      height: MediaQuery.of(context).size.height*0.35,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover)),
            ),
          ),
            Text(document["name"],style: Theme.of(context).textTheme.headline4,),
            Text(document["description"],style: Theme.of(context).textTheme.bodyText1,),
            Text(DateTime.parse(document["date"].toDate().toString()).toString()
              ,style: Theme.of(context).textTheme.bodyText1,),
            Text(document["uid"],style: Theme.of(context).textTheme.bodyText1,),
          ]
        )
    );
  }
}

