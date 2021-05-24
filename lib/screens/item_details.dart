import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class FoodDetails extends StatelessWidget {
  final document;
  final tag;
  FoodDetails(this.tag,this.document);
  Widget _displayImage(String uri, BuildContext context)
  {
    if(uri.isEmpty)
    {
      return Image.asset("assets/img/product-placeholder.jpg",
        fit: BoxFit.cover,
        height: MediaQuery.of(context).size.height*0.35,
        width: MediaQuery.of(context).size.width,);
    }
    else
    {
      return FadeInImage(
        fit: BoxFit.cover,
        height: MediaQuery.of(context).size.height*0.35,
        width: MediaQuery.of(context).size.width,
        image: NetworkImage(
          uri,
        ),
        placeholder: MemoryImage(kTransparentImage)
        ,
      );
    }
  }
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
                  child: _displayImage(document["image_url"],context)
            ),
          )),
            Text(document["name"],style: Theme.of(context).textTheme.headline4,),
            Text(document["description"],style: Theme.of(context).textTheme.bodyText1,),
            Text(DateTime.parse(document["expiration_date"].toDate().toString()).toString()
              ,style: Theme.of(context).textTheme.bodyText1,),
            Text(document["uid"],style: Theme.of(context).textTheme.bodyText1,),
          ]
        )
    );
  }
}

