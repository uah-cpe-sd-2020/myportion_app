import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myportion_app/model/Pet.dart';
import 'package:myportion_app/services/Authenticate.dart';
import 'package:myportion_app/ui/home/HomeScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myportion_app/services/helper.dart';
import 'package:intl/intl.dart';  //for date format

import '../../constants.dart' as Constants;
import '../../constants.dart';
import '../../main.dart';

File _image;

class AddPetProfileScreen extends StatefulWidget {
  @override
  State createState() => _AddPetProfileState();
}

class _AddPetProfileState extends State<AddPetProfileScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  TextEditingController timeCtl_1 = new TextEditingController();
  TextEditingController timeCtl_2 = new TextEditingController();
  GlobalKey<FormState> _key = new GlobalKey();
  AutovalidateMode _validate = AutovalidateMode.disabled;
  String petName;
  String feederID;
  String singleTime;
  List scheduleFeeding;

  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm();  //"6:00 AM"
    return format.format(dt);
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      retrieveLostData();
    }

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

  Future<void> retrieveLostData() async {
    final LostData response = await _imagePicker.getLostData();
    if (response == null) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image = File(response.file.path);
      });
    }
  }

  _onCameraClick() {
    final action = CupertinoActionSheet(
      message: Text(
        "Add profile picture",
        style: TextStyle(fontSize: 15.0),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text("Choose from gallery"),
          isDefaultAction: false,
          onPressed: () async {
            Navigator.pop(context);
            PickedFile image =
            await _imagePicker.getImage(source: ImageSource.gallery);
            if (image != null)
              setState(() {
                _image = File(image.path);
              });
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Take a picture"),
          isDestructiveAction: false,
          onPressed: () async {
            Navigator.pop(context);
            PickedFile image =
            await _imagePicker.getImage(source: ImageSource.camera);
            if (image != null)
              setState(() {
                _image = File(image.path);
              });
          },
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text("Cancel"),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
  }

  Widget formUI() {
    return new Column(
      children: <Widget>[
        new Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Create new pet profile',
              style: TextStyle(
                  color: Color(Constants.COLOR_PRIMARY),
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0),
            )),
        Padding(
          padding:
          const EdgeInsets.only(left: 8.0, top: 32, right: 8, bottom: 8),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              CircleAvatar(
                radius: 65,
                backgroundColor: Colors.grey.shade400,
                child: ClipOval(
                  child: SizedBox(
                    width: 170,
                    height: 170,
                    child: _image == null
                        ? Image.asset(
                      'assets/images/placeholder.jpg',
                      fit: BoxFit.cover,
                    )
                        : Image.file(
                      _image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 80,
                right: 0,
                child: FloatingActionButton(
                    backgroundColor: Color(COLOR_ACCENT),
                    child: Icon(Icons.camera_alt),
                    mini: true,
                    onPressed: _onCameraClick),
              )
            ],
          ),
        ),
        ConstrainedBox(
            constraints: BoxConstraints(minWidth: double.infinity),
            child: Padding(
                padding:
                const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
                child: TextFormField(
                    key: Key('PetName'),
                    validator: validateName,
                    onSaved: (String val) {
                      petName = val;
                    },
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    decoration: InputDecoration(
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        fillColor: Colors.white,
                        hintText: 'Pet Name',
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(
                                color: Color(Constants.COLOR_PRIMARY),
                                width: 2.0)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ))))),
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: double.infinity),
          child: Padding(
            padding:
            const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
            child:  DropdownButton<String>(
              hint: Text('Select Feeder ID'),
              value: feederID,
              icon: Icon(Icons.keyboard_arrow_down),
              iconSize: 15,
              elevation: 16,
              style: TextStyle(color: Colors.grey),
              underline: Container(
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1.0, style: BorderStyle.solid),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
              ),
              onChanged: (String newValue) {
                setState(() {
                  feederID = newValue;
                });},
              items: <String>['Feeder 1', 'Feeder 2', 'Feeder 3']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text( value,
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Color.fromRGBO(54, 38, 83, 1)),
                  ),
                );
              }).toList(),
            ),
          ),  ),
        ConstrainedBox(
            constraints: BoxConstraints(minWidth: double.infinity),
            child: Padding(
                padding:
                const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
                child: TextFormField(
                    controller: timeCtl_1,
                    key: Key('ScheduleFeeding1'),
                    onTap: () async {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      final TimeOfDay newTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(hour: 7, minute: 15),
                        initialEntryMode: TimePickerEntryMode.input,
                      );
                      if (newTime != null) setState(
                              () => { singleTime = newTime.toString(),
                                timeCtl_1.text = formatTimeOfDay(newTime)
                          }
                      );
                    },
                    onSaved: (value){
                      scheduleFeeding.insert(0, value);
                    },
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    decoration: InputDecoration(
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        fillColor: Colors.white,
                        hintText: 'Schedule Feeding 1',
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(
                                color: Color(Constants.COLOR_PRIMARY),
                                width: 2.0)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ))))),
        ConstrainedBox(
            constraints: BoxConstraints(minWidth: double.infinity),
            child: Padding(
                padding:
                const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
                child: TextFormField(
                    controller: timeCtl_2,
                    key: Key('ScheduleFeeding2'),
                    onTap: () async {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      final TimeOfDay newTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(hour: 7, minute: 15),
                        initialEntryMode: TimePickerEntryMode.input,
                      );
                      if (newTime != null) setState(
                              () => { singleTime = newTime.toString(),
                                timeCtl_2.text = formatTimeOfDay(newTime)
                          }
                      );
                    },
                    onSaved: (value){
                      scheduleFeeding.insert(1, value);
                    },
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    decoration: InputDecoration(
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        fillColor: Colors.white,
                        hintText: 'Schedule Feeding 2',
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(
                                color: Color(Constants.COLOR_PRIMARY),
                                width: 2.0)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ))))),
        Padding(
          padding: const EdgeInsets.only(right: 40.0, left: 40.0, top: 40.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: double.infinity),
            child: RaisedButton(
              color: Color(Constants.COLOR_PRIMARY),
              child: Text(
                'Add Pet',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              textColor: Colors.white,
              splashColor: Color(Constants.COLOR_PRIMARY),
              //onPressed: _sendToServer
              padding: EdgeInsets.only(top: 12, bottom: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  side: BorderSide(color: Color(Constants.COLOR_PRIMARY))),
              key: Key('AddPetButton'),
            ),
          ),
        ),
      ],
    );
  }

/*_sendToServer() async {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      showProgress(context, 'Adding new pet, Please wait...', false);
      var profilePicUrl = '';
      try {
        if (_image != null) {
          updateProgress('Uploading image, Please wait...');
          profilePicUrl = await FireStoreUtils()
              .uploadUserImageToFireStorage(_image, pet.uid);
        }
        Pet pet = Pet(
            petName: petName,
            feederID: feederID,
            scheduleFeeding: scheduleFeeding,
            active: true,
            petProfilePictureURL: profilePicUrl);
        await FireStoreUtils.firestore
            .collection(Constants.USERS)
            .doc(result.user.uid)
            .set(user.toJson());
        await FireStoreUtils.firestore.collection(Constants.PETS).
        hideProgress();
        MyAppState.currentUser = user;
        pushAndRemoveUntil(context, HomeScreen(user: user), false);
      } on auth.FirebaseAuthException catch (error) {
        hideProgress();
        String message = 'Couldn\'t sign up';
        switch (error.code) {
          case 'email-already-in-use':
            message = 'Email address already in use';
            break;
          case 'invalid-email':
            message = 'validEmail';
            break;
          case 'operation-not-allowed':
            message = 'Email/password accounts are not enabled';
            break;
          case 'weak-password':
            message = 'password is too weak.';
            break;
          case 'too-many-requests':
            message = 'Too many requests, '
                'Please try again later.';
            break;
        }
        showAlertDialog(context, 'Failed', message);
        print(error.toString());
      } catch (e) {
        print('_SignUpState._sendToServer $e');
        hideProgress();
        showAlertDialog(context, 'Failed', 'Couldn\'t sign up');
      }
    } else {
      setState(() {
        _validate = AutovalidateMode.onUserInteraction;
      });
    }
  }*/
}
