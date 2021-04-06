import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myportion_app/constants.dart';
import 'package:myportion_app/model/User.dart';
import 'package:myportion_app/ui/FeederList/FeederListScreen.dart';
import 'package:myportion_app/model/Feeder.dart';
import 'package:myportion_app/ui/addPet/AddPetProfileScreen.dart';
import 'package:myportion_app/ui/PetList/PetListScreen.dart';
import 'package:myportion_app/model/Pet.dart';
import 'package:myportion_app/ui/ScheduleList/ScheduleList.dart';
import 'package:myportion_app/ui/addSchedule/AddScheduleScreen.dart';
import 'package:myportion_app/services/FirestoreUtils.dart';
import 'package:myportion_app/ui/auth/AuthScreen.dart';

import 'package:myportion_app/services/helper.dart';

import 'package:myportion_app/main.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  HomeScreen({Key key, @required this.user}) : super(key: key);

  @override
  State createState() {
    return _HomeState(user);
  }
}

class _HomeState extends State<HomeScreen> {
  final User user;
  String feederName;
  String feederID;

  _HomeState(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      displayCircleImage(user.profilePictureURL, 80, false),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(user.firstName),
                      ),
                    ]
                ),
                decoration: BoxDecoration(
                  color: Color(COLOR_PRIMARY),
                ),
              ),
              ListTile(
                title: Text(
                  'Logout',
                  style: TextStyle(color: Colors.black),
                ),
                leading: Transform.rotate(
                    angle: pi / 1,
                    child: Icon(Icons.exit_to_app, color: Colors.black)),
                onTap: () async {
                  user.active = false;
                  user.lastOnlineTimestamp = Timestamp.now();
                  FireStoreUtils.updateCurrentUser(user);
                  await auth.FirebaseAuth.instance.signOut();
                  MyAppState.currentUser = null;
                  pushAndRemoveUntil(context, AuthScreen(), false);
                },
              ),
              ListTile(
                title: Text(
                  'Feeder List',
                  style: TextStyle(color: Colors.black),
                ),
                leading: Transform.rotate(
                    angle: 0,
                    child: Icon(
                      Icons.local_dining,
                      color: Colors.black,
                    )),
                onTap: () async {
                  pushReplacement(context, new FeederListScreen());
                },
              ),
              ListTile(
                title: Text(
                  'Pet List',
                  style: TextStyle(color: Colors.black),
                ),
                leading: Transform.rotate(
                    angle: 0, child: Icon(Icons.pets, color: Colors.black)),
                onTap: () async {
                  pushReplacement(context, new PetListScreen());
                },
              ),
              ListTile(
                title: Text(
                  'Schedule List',
                  style: TextStyle(color: Colors.black),
                ),
                leading: Transform.rotate(
                    angle: 0, child: Icon(Icons.schedule, color: Colors.black)),
                onTap: () async {
                  pushReplacement(context, new ScheduleList());
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text(
            'Home',
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: FutureBuilder<List>(
                    future: FireStoreUtils().getFeederList(),
                    initialData: List(),
                    builder: (context, snapshot) {
                      return snapshot.hasData ? DropdownButton<String>(
                        hint: Text('Select Feeder ID'),
                        value: feederName,
                        icon: Icon(Icons.keyboard_arrow_down),
                        iconSize: 20,
                        elevation: 16,
                        style: TextStyle(color: Colors.grey),
                        underline: Container(
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 1.0, style: BorderStyle.solid),
                              borderRadius:
                              BorderRadius.all(Radius.circular(5.0)),
                            ),
                          ),
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            feederName = newValue;
                            feederID = snapshot.data[snapshot.data.indexWhere( (item) =>
                            item.name == newValue)].id;
                          });
                        },
                        items: snapshot.data.map((value) =>
                            DropdownMenuItem<String>(
                              child: Text(
                                value.name,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Color.fromRGBO(54, 38, 83, 1)),
                              ),
                              value: value.name,
                            )).toList(),
                      )
                      : new CircularProgressIndicator();
                    }
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: FutureBuilder<List>(
                  future: FireStoreUtils().getAllPets(),
                  initialData: List(),
                  builder: (context, snapshot) {
                    return snapshot.hasData ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (_, int position) {
                        final item = snapshot.data[position];
                        //get your item data here ...
                        return Card(
                          child: ListTile(
                            title: Text(item.name + ' - ' + item.type),
                            trailing: Wrap(
                              spacing: 12,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () async {
                                    FireStoreUtils().removePet(item);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.more_vert),
                                  onPressed: () async {
                                    Feeder feeder = await FireStoreUtils()
                                        .getFeederFromPet(item.id);
                                    pushReplacement(
                                        context,
                                        new AddPetProfileScreen(
                                            item, feeder.name, feeder.id));
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                    : CircularProgressIndicator();
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Next up...")
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: FutureBuilder<List>(
                  future: FireStoreUtils().getAllSchedules(),
                  initialData: List(),
                  builder: (context, snapshot) {
                    return snapshot.hasData ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (_, int position) {
                        final item = snapshot.data[position];
                        //get your item data here ...
                        return Card(
                          child: ListTile(
                            title: Text(item.petName + ' - ' + item.name),
                            trailing: Wrap(
                              spacing: 12,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () async {
                                    await FireStoreUtils()
                                        .getPetFromSchedule(item.id);
                                    FireStoreUtils().removeSchedule(item);
                                    pushReplacement(
                                        context, new ScheduleList());
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.more_vert),
                                  onPressed: () async {
                                    Pet pet = await FireStoreUtils()
                                      .getPetFromSchedule(item.id);
                                    push(
                                      context,
                                      new AddScheduleScreen(
                                        item, pet.name, pet.id));
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                    : CircularProgressIndicator();
                  },
                ),
              )
            )
          ]
        ),
    );
  }
}
