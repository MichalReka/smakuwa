import 'package:flutter/material.dart';

class FoodDetails extends StatelessWidget {
  final image;
  final tag;
  FoodDetails(this.tag,this.image);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
        child: Column(
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
                  child: Image.asset(
                      image,
                      height: MediaQuery.of(context).size.height*0.35,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover)),
            ),
          ),
            Text("dihauwjh iwajdiwaj idja widjiwa jidj waidj waidj wiajd iwajd iwajd iwaj id")
          ]
        )
    );
  }
}

