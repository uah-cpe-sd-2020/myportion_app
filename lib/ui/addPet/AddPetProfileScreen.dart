import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myportion_app/model/Feeder.dart';
import 'package:myportion_app/model/Pet.dart';
import 'package:myportion_app/model/Schedule.dart';
import 'package:myportion_app/services/FirestoreUtils.dart';
import 'package:myportion_app/ui/PetList/PetListScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myportion_app/services/helper.dart';
import 'package:intl/intl.dart'; //for date format
import 'package:myportion_app/constants.dart';
import 'package:myportion_app/ui/ScheduleList/ScheduleList.dart';
import 'package:myportion_app/ui/addSchedule/AddScheduleScreen.dart';

File _image;

class AddPetProfileScreen extends StatefulWidget {
  final Pet pet;

  AddPetProfileScreen({@required this.pet});
  @override
  State createState() =>
      _AddPetProfileScreenState(pet, pet.name, pet.dob ?? DateFormat("yyyy-MM-dd").format(DateTime.now()), pet.type, pet.lbs, pet.petProfilePictureURL);
}

class _AddPetProfileScreenState extends State<AddPetProfileScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  TextEditingController timeCtl = new TextEditingController();
  TextEditingController dateCtl = new TextEditingController();
  GlobalKey<FormState> _key = new GlobalKey();
  AutovalidateMode _validate = AutovalidateMode.disabled;
  Pet pet;
  String petName;
  String dob;
  String type;
  var lbs;
  var petProfilePictureUrl;
  List<Feeder> feeders = [];
  String feederID;
  String singleTime;
  DateTime selectedDate;
  DateTime dateOfBirth;
  String portionsLabel = "Portions: ";

  _AddPetProfileScreenState(this.pet, this.petName, this.dob, this.type, this.lbs, this.petProfilePictureUrl);

  Future<void> _selectDate(BuildContext context) async {
    var temp = dob.split("-");
    String year = temp.elementAt(0);
    String month = temp.elementAt(1);
    String day = temp.elementAt(2);
    selectedDate = DateTime.parse(year+"-"+month+"-"+day);
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: selectedDate ?? DateTime.now(),
        firstDate: DateTime(2000,1,1),
        lastDate: DateTime(2050,1,1));
    if (pickedDate != null && pickedDate != selectedDate)
      setState(() {
        selectedDate = pickedDate;
        dateOfBirth = pickedDate;
      });
  }

  addSchedule() async {
    pushReplacement(context, new AddScheduleScreen(schedule: new Schedule()));
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      retrieveLostData();
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(COLOR_PRIMARY),
        title: Text('Update Pet'),
        leading: IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () async {
            pushReplacement(context, PetListScreen());
          },
        ),
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

  Future<void> retrieveLostData() async {
    final LostData response = await _imagePicker.getLostData();
    if (response == null) {
      return;
    }
    if (response.file != null) {
      setState(() {
        petProfilePictureUrl = File(response.file.path);
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
                petProfilePictureUrl = File(image.path);
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
                petProfilePictureUrl = File(image.path);
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
            ),
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
            padding: const EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0),
            child: new DropdownButton<String>(
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
                    const EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0),
                child: TextFormField(
                    initialValue: petName,
                    key: Key('PetName'),
                    validator: validateName,
                    onSaved: (String val) {
                      petName = val;
                    },
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    decoration: InputDecoration(
                        labelText: 'Pet Name',
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        fillColor: Colors.white,
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
                padding:
                const EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0),
                child: new TextFormField(
                          controller: dateCtl,
                          key: Key('DateOfBirth'),
                          onTap: () async {
                            FocusScope.of(context).requestFocus(new FocusNode());
                            await _selectDate(context);
                            dateCtl.text = DateFormat('yyyy-MM-dd').format(selectedDate);
                          },
                          decoration: InputDecoration(
                          labelText: 'Date of Birth',
                          contentPadding:
                            new EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          fillColor: Colors.white,
                          hintText: 'Date of Birth',
                          focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide:
                            BorderSide(color: Color(COLOR_PRIMARY), width: 2.0)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),),
                        ),),
                    ),
            ),
        ConstrainedBox(
            constraints: BoxConstraints(minWidth: double.infinity),
            child: Padding(
                padding:
                const EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0),
                child: TextFormField(
                    initialValue: lbs,
                    key: Key('Weight'),
                    onSaved: (String val) {
                      lbs = val;
                    },
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    decoration: InputDecoration(
                        labelText: 'Weight',
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        fillColor: Colors.white,
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
            padding: const EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0),
            child: new DropdownButton<String>(
              hint: Text('Select Pet Type'),
              value: type,
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
                  type = newValue;
                });
              },
              items: <String>['Cat', 'Dog']
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
        Container(
          width: 350,
          height: 400,
          child: new ScheduleList(),
           ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: double.infinity),
            child: RaisedButton(
              color: Color(COLOR_PRIMARY),
              child: Text(
                'Submit',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              textColor: Colors.white,
              splashColor: Color(COLOR_PRIMARY),
              onPressed: _sendToServer,
              padding: EdgeInsets.only(top: 12, bottom: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  side: BorderSide(color: Color(COLOR_PRIMARY))),
              key: Key('UpdatePet'),
            ),
          ),
        ),
      ],
    );
  }

  _sendToServer() async {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      showProgress(context, 'Updating pet, Please wait...', false);
      try {
        /*BEGIN*/
        //Remove once add-a-feeder is established
        await FireStoreUtils()
            .addFeeder(new Feeder(modelType: "Model1", name: "Feeder"));
        /*END*/
        pet.rfid = '';
        pet.name = petName;
        pet.dob = DateFormat("yyyy-MM-dd").format(dateOfBirth);
        pet.type = type;
        pet.lbs = lbs;
        pet.petProfilePictureURL = petProfilePictureUrl;

        if (pet.id == null) {
          pet = await FireStoreUtils().addPet(pet);
        }

        await FireStoreUtils().updatePet(pet);
        pushAndRemoveUntil(context, PetListScreen(), false);
      } catch (e) {
        print('_updatepet._sendToServer $e');
        hideProgress();
        showAlertDialog(context, 'Failed', 'Couldn\'t update pet profile');
      }
    } else {
      setState(() {
        _validate = AutovalidateMode.onUserInteraction;
      });
    }
  }
}

