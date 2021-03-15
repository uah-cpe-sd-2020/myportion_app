import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myportion_app/constants.dart';
import 'package:myportion_app/main.dart';
import 'package:myportion_app/model/Feeder.dart';
import 'package:myportion_app/services/helper.dart';
import 'package:myportion_app/ui/addFeeder/AddFeederScreen.dart';
import 'package:myportion_app/services/FirestoreUtils.dart';
import 'package:myportion_app/ui/home/HomeScreen.dart';

class FeederListScreen extends StatefulWidget {
  @override
  State createState() => _FeederListScreenState();
}

class _FeederListScreenState extends State<FeederListScreen> {
  _FeederListScreenState();

  GlobalKey<FormState> _key = new GlobalKey();
  AutovalidateMode _validate = AutovalidateMode.disabled;
  List<Feeder> feeders = [];

  addFeeder() async {
    pushReplacement(context, new AddFeederScreen(feeder: new Feeder()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(COLOR_PRIMARY),
        title: Text('List Of Feeders'),
        leading: IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () async {
            pushReplacement(
                context, HomeScreen(key: null, user: MyAppState.currentUser));
          },
        ),
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: new Container(
          margin: new EdgeInsets.only(left: 2.0, right: 2, bottom: 2),
          child: new Form(
            key: _key,
            autovalidateMode: _validate,
            child: formUI(),
          ),
        ),
      ),
    );
  }

  Widget formUI() {
    return new Column(
      children: <Widget>[
        SizedBox(
          height: 670,
          child: Scaffold(
            body: FutureBuilder<List>(
              future: FireStoreUtils().getFeederList(),
              initialData: List(),
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (_, int position) {
                          final item = snapshot.data[position];
                          //get your item data here ...
                          return Card(
                            child: ListTile(
                                title: Text(item.name + ' - ' + item.modelType),
                                trailing: Icon(Icons.more_vert),
                                onTap: () async {
                                  pushReplacement(context,
                                      new AddFeederScreen(feeder: item));
                                }),
                          );
                        },
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      );
              },
            ),
            floatingActionButton: FloatingActionButton(
                heroTag: "addFeeder",
                onPressed: addFeeder,
                child: new Icon(Icons.add)),
          ),
        ),
      ],
    );
  }
}
