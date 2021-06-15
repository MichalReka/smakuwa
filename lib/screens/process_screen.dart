import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smakuwa/models/item_add_model.dart';
class ProcessScreen extends StatelessWidget {
  final Function futureOperation;
  final String onEnd;
  final String onError;
  final String process;
  const ProcessScreen({Key key, this.futureOperation, this.onEnd, this.onError, this.process}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Center(
            child: FutureBuilder(
                future: futureOperation(),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data == true) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            onEnd,
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          Icon(
                              Icons.done_rounded,
                              color: Colors.green,
                              size: 70
                          ),
                          ElevatedButton(onPressed: (){
                            Navigator.pop(context);
                          }, child: Text("Wróć"))
                        ],
                      );
                    } else {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                onError,
                                style: Theme.of(context).textTheme.headline4,
                              ),
                              Icon(
                                Icons.close_rounded,
                                color: Colors.red,
                                size: 80,
                              )
                            ]),
                      );
                    }
                  } else {
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            process,
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          CircularProgressIndicator()
                        ]);
                  }
                }),
          )
      );
  }
}