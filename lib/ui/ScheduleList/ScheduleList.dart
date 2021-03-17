
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myportion_app/constants.dart';
import 'package:myportion_app/model/Schedule.dart';
import 'package:myportion_app/services/helper.dart';
import 'package:myportion_app/services/FirestoreUtils.dart';
import 'package:myportion_app/ui/addSchedule/AddScheduleScreen.dart';

class ScheduleList extends StatefulWidget {
  @override
  State createState() => _ScheduleListState();
}

class _ScheduleListState extends State<ScheduleList> {
  _ScheduleListState();

  GlobalKey<FormState> _key = new GlobalKey();
  AutovalidateMode _validate = AutovalidateMode.disabled;

  addSchedule() async {
    pushReplacement(context, new AddScheduleScreen(schedule: new Schedule()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(COLOR_PRIMARY),
        title: Text('Feeding Schedules'),
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
          height: 350,
          width: 330,
          child: Scaffold(
            body: FutureBuilder<List>(
              future: FireStoreUtils().getScheduleList(),
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
                        title: Text(item.name),
                        trailing: Wrap(
                          spacing: 12,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () async {
                                FireStoreUtils().removeSchedule(item);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.more_vert),
                              onPressed: () async {
                                pushReplacement(context,
                                    new AddScheduleScreen(schedule: item));
                              },
                            ),
                          ],
                        ),),
                    );
                  },
                )
                    : Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
                heroTag: "addSchedule",
                onPressed: addSchedule,
                child: new Icon(Icons.add)),
          ),
        ),
      ],
    );
  }
}