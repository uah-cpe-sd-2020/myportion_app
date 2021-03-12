import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myportion_app/constants.dart';
import 'package:myportion_app/model/User.dart';
import 'package:myportion_app/ui/addFeeder/AddFeederScreen.dart';
import 'package:myportion_app/ui/addPet/AddPetProfileScreen.dart';
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

  _HomeState(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'Drawer Header',
                style: TextStyle(color: Colors.white),
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
                'Add Pet Profile',
                style: TextStyle(color: Colors.black),
              ),
              leading: Transform.rotate(
                  angle: pi / 1, child: Icon(Icons.pets, color: Colors.black)),
              onTap: () async {
                pushReplacement(context, new AddPetProfileScreen());
              },
            ),
            ListTile(
              title: Text(
                'Update Feeder',
                style: TextStyle(color: Colors.black),
              ),
              leading: Transform.rotate(
                  angle: pi / 1, child: Icon(Icons.local_dining, color: Colors.black)),
              onTap: () async {
                pushReplacement(context, new AddFeederScreen());
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            displayCircleImage(user.profilePictureURL, 125, false),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(user.firstName),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(user.email),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(user.phoneNumber),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(user.id),
            ),
          ],
        ),
      ),
    );
  }
}
