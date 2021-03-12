import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myportion_app/constants.dart';
import 'package:myportion_app/services/helper.dart';
import 'package:myportion_app/ui/addFeeder/AddFeederScreen.dart';

class FeederListScreen extends StatefulWidget {
  final User user;

  FeederListScreen({Key key, @required this.user}) : super(key: key);

  @override
  State createState() => _FeederListScreenState(user);
}

class _FeederListScreenState extends State<FeederListScreen> {
  final User user;

  _FeederListScreenState(this.user);

  GlobalKey<FormState> _key = new GlobalKey();
  AutovalidateMode _validate = AutovalidateMode.disabled;
  //List<Feeder> feeders = ;
  List<DynamicFeeders> listDynamic = [];

  addDynamic() {
    listDynamic.add(new DynamicFeeders());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: new Container(
          margin: new EdgeInsets.only(left: 16.0, right: 16, bottom: 16),
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
    GlobalKey<FormState> _key = new GlobalKey();
    AutovalidateMode _validate = AutovalidateMode.disabled;
    return new Column(
      children: <Widget>[
       Scaffold(
         body: Container(
           alignment: Alignment.topCenter,
           child: ListView(
             padding: EdgeInsets.zero,
             children: <Widget>[
               DrawerHeader(
                 child: Text(
                   'Feeder List',
                   style: TextStyle(color: Colors.white),
                 ),
                 decoration: BoxDecoration(
                   color: Color(COLOR_PRIMARY),
                 ),
               ),
               ConstrainedBox(
                   constraints: BoxConstraints(minWidth: double.infinity),
                   child: Padding(
                     padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
                     child: new Container(
                         child: new Column(children: [
                           new Column(children: <Widget>[
                             new SizedBox(
                               child: new ListView.builder(
                                 padding: const EdgeInsets.all(8),
                                 //itemCount: feeders.length,
                                 itemBuilder: (BuildContext context, int index){
                                   return Container(
                                     height: 30,
                                     margin: EdgeInsets.all(2),
                                     child: Center(
                                       //child: Text('${feeders[index]}'),
                                     ),
                                   );
                                 },
                               ),
                               height: 400.0,
                             ),
                             new SizedBox(
                                 height: 400.0,
                                 child: new ListView.builder(
                                     itemCount: listDynamic.length,
                                     itemBuilder: (_, index) => listDynamic[index])
                             ),
                             new FloatingActionButton(
                               heroTag: "addFeeder",
                               onPressed: addDynamic,
                               child: new Icon(Icons.add)
                           ),
                         ]),
                    ],),),
                  ),
           ),
         ],
       ),
      ),),],
    );
  }
}

// ignore: must_be_immutable
class DynamicFeeders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: new ListTile(
        title: Text(
          'FeederName',//feeder number 1
          style: TextStyle(color: Colors.black),
        ),
        leading: Transform.rotate(
            angle: pi / 1,
            child: Icon(Icons.local_dining, color: Colors.black)),
        onTap: () async {
          pushReplacement(context, new AddFeederScreen());//addFeederScreen
        },
      ),
    );
  }
}



