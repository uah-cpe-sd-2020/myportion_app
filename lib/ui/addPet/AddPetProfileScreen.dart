import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myportion_app/model/Feeder.dart';
import 'package:myportion_app/model/Pet.dart';
import 'package:myportion_app/model/Schedule.dart';
import 'package:myportion_app/services/FirestoreUtils.dart';
import 'package:myportion_app/ui/home/HomeScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myportion_app/services/helper.dart';
import 'package:intl/intl.dart'; //for date format
import 'package:myportion_app/constants.dart';
import 'package:myportion_app/main.dart';

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
  List scheduleFeeding = [];
  List<DynamicScheduling> listDynamic = [];
  int count = 0;

  addDynamic() {
    if (listDynamic.length >= 5) {
      return;
    }
    listDynamic.add(new DynamicScheduling());
    setState(() {});
  }

  submitFeeding() {
    listDynamic.forEach(
        (widget) => scheduleFeeding.insert(count, widget.timeCtl.text));
    count = count + 1;
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
                  color: Color(COLOR_PRIMARY),
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
                    heroTag: "photo",
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
            padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
            child: DropdownButton<String>(
              hint: Text('Select Feeder ID'),
              value: feederID,
              icon: Icon(Icons.keyboard_arrow_down),
              iconSize: 20,
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
                });
              },
              items: <String>['Feeder 1', 'Feeder 2', 'Feeder 3']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Color.fromRGBO(54, 38, 83, 1)),
                  ),
                );
              }).toList(),
            ),
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
                                color: Color(COLOR_PRIMARY), width: 2.0)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ))))),
        ConstrainedBox(
            constraints: BoxConstraints(minWidth: double.infinity),
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
              child: new Container(
                  child: new Column(children: [
                new Column(children: <Widget>[
                  new SizedBox(
                      height: 150.0,
                      child: new ListView.builder(
                          itemCount: listDynamic.length,
                          itemBuilder: (_, index) => listDynamic[index])),
                  new Container(
                      child: new RaisedButton(
                          onPressed: submitFeeding,
                          child: Text('Submit Feeding Time')))
                ]),
                new FloatingActionButton(
                    heroTag: "addFeedingTime",
                    onPressed: addDynamic,
                    child: new Icon(Icons.add)),
              ])),
            )),
        Padding(
          padding: const EdgeInsets.only(right: 40.0, left: 40.0, top: 40.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: double.infinity),
            child: RaisedButton(
              color: Color(COLOR_PRIMARY),
              child: Text(
                'Add Pet',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              textColor: Colors.white,
              splashColor: Color(COLOR_PRIMARY),
              onPressed: _sendToServer,
              padding: EdgeInsets.only(top: 12, bottom: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  side: BorderSide(color: Color(COLOR_PRIMARY))),
              key: Key('AddPetButton'),
            ),
          ),
        ),
      ],
    );
  }

  _sendToServer() async {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      showProgress(context, 'Adding new pet, Please wait...', false);
      var profilePicUrl = '';
      try {
        /*BEGIN*/
        //Remove once add-a-feeder is established
        await FireStoreUtils()
            .addFeeder(new Feeder(modelType: "Model1", name: "Feeder"));
        /*END*/
        Pet pet = Pet(
            rfid: '',
            dob: Timestamp.now(),
            id: '',
            name: petName,
            type: 'Dog',
            lbs: 17,
            petProfilePictureURL: profilePicUrl);
        pet = await FireStoreUtils().addPet(pet);
        if (_image != null) {
          updateProgress('Uploading image, Please wait...');
          profilePicUrl = await FireStoreUtils()
              .uploadUserImageToFireStorage(_image, pet.id);
        }
        Schedule sched = Schedule(
          time: scheduleFeeding,
        );
        await FireStoreUtils().addSchedule(sched);
        pushAndRemoveUntil(
            context, HomeScreen(user: MyAppState.currentUser), false);
      } catch (e) {
        print('_addpet._sendToServer $e');
        hideProgress();
        showAlertDialog(context, 'Failed', 'Couldn\'t add pet');
      }
    } else {
      setState(() {
        _validate = AutovalidateMode.onUserInteraction;
      });
    }
  }
}

// ignore: must_be_immutable
class DynamicScheduling extends StatelessWidget {
  TextEditingController timeCtl = new TextEditingController();
  List dynamicScheduleFeeding = [];
  String singleTime;

  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new TextFormField(
        controller: timeCtl,
        key: Key('ScheduleFeeding'),
        onTap: () async {
          FocusScope.of(context).requestFocus(new FocusNode());
          final TimeOfDay newTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay(hour: 7, minute: 15),
            initialEntryMode: TimePickerEntryMode.input,
          );
          if (newTime != null) {
            singleTime = newTime.toString();
            timeCtl.text = formatTimeOfDay(newTime);
          }
        },
        onSaved: (value) {
          dynamicScheduleFeeding.add(value);
        },
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
        decoration: InputDecoration(
            contentPadding:
                new EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            fillColor: Colors.white,
            hintText: 'Schedule Feeding',
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide:
                    BorderSide(color: Color(COLOR_PRIMARY), width: 2.0)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
            )),
      ),
    );
  }
}
