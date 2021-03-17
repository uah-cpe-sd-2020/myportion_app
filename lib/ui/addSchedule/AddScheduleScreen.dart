import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myportion_app/model/Schedule.dart';
import 'package:myportion_app/services/FirestoreUtils.dart';
import 'package:myportion_app/services/helper.dart';
import 'package:myportion_app/constants.dart';
import 'package:intl/intl.dart';

class AddScheduleScreen extends StatefulWidget {
  final Schedule schedule;

  AddScheduleScreen({@required this.schedule});
  @override
  State createState() =>
      _AddScheduleScreenState(schedule, schedule.name, schedule.portion ?? 1, schedule.time?? DateFormat.Hm().format(DateTime.now()));
}

class _AddScheduleScreenState extends State<AddScheduleScreen> {
  GlobalKey<FormState> _key = new GlobalKey();
  AutovalidateMode _validate = AutovalidateMode.disabled;
  TextEditingController timeCtl = new TextEditingController();
  Schedule schedule;
  String scheduleName;
  var portion;
  String time;
  DateTime timeOfFeeding;
  TimeOfDay selectedTime;
  String portionsLabel = "Portions: ";

  _AddScheduleScreenState(this.schedule, this.scheduleName, this.portion, this.time);

  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }

  Future<Null> _selectTime(BuildContext context) async {
    print("Time: $time");
    var temp = time.split(":");
    selectedTime = TimeOfDay.fromDateTime(DateTime.now());
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        timeOfFeeding = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, picked.hour, picked.minute);
      });}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(COLOR_PRIMARY),
        title: Text('Update Schedule'),
        leading: IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () async {
            //pushReplacement(context, AddPetProfileScreen(pet: FireStoreUtils().petID));
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

  Widget formUI() {
    return new Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 10.0, left: 10.0, top: 10.0),
          child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: double.infinity),
              child: Padding(
                  padding:
                  const EdgeInsets.only(top: 5.0, right: 5.0, left: 5.0),
                  child: TextFormField(
                      key: Key('ScheduleName'),
                      validator: validateName,
                      onSaved: (String val) {
                        scheduleName = val;
                      },
                      initialValue: scheduleName,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).nextFocus(),
                      decoration: InputDecoration(
                          labelText: 'Schedule Name',
                          labelStyle: TextStyle(
                            fontSize: 18,
                          ),
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                  color: Color(COLOR_PRIMARY), width: 2.0)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ))))),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10.0, left: 10.0, top: 10.0),
          child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: double.infinity),
              child: Padding(
                  padding:
                  const EdgeInsets.only(top: 5.0, right: 5.0, left: 5.0),
                child: new TextFormField(
                  controller: timeCtl,
                  key: Key('FeedingTime'),
                  onTap: () async {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    await _selectTime(context);
                    timeCtl.text = DateFormat.Hm().format(timeOfFeeding);
                  },
                  decoration: InputDecoration(
                    labelText: 'Feeding Time',
                    contentPadding:
                    new EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    fillColor: Colors.white,
                    hintText: 'Feeding Time',
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide:
                        BorderSide(color: Color(COLOR_PRIMARY), width: 2.0)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),),
                  ),),)),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10.0, left: 10.0, top: 10.0),
          child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: double.infinity),
              child: Padding(
                  padding:
                  const EdgeInsets.only(top: 5.0, right: 5.0, left: 5.0),
                child: new Container(
                  decoration: new BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: new Border.all(
                      color: Colors.grey[300],
                      width: 2.0,
                    ),
                  ),
                  child: new Column(children:<Widget>[
                    new TextField(
                      controller: new TextEditingController(text: portionsLabel+portion.toString()),
                      enabled: false,
                      decoration: InputDecoration(
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 16, horizontal: 16),
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius. circular(25.0),
                            borderSide: new BorderSide(
                                color: Color(COLOR_PRIMARY), width: 1.0)),
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                              const Radius.circular(0.0)),
                        ),),),
                    new Slider(
                        min: 0,
                        max: 5,
                        value: portion.toDouble(),
                        divisions: 5,
                        label: portion.toString(),
                        onChanged: (val){
                          setState((){portion = val;});
                        }
                    ),
                  ]),
                ),)),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10.0, left: 10.0, top: 10.0),
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
              //onPressed: _sendToServer,
              padding: EdgeInsets.only(top: 12, bottom: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  side: BorderSide(color: Color(COLOR_PRIMARY))),
              key: Key('SubmitButton'),
            ),
          ),
        ),
      ],
    );
  }

  _sendToServer() async {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      showProgress(context, 'Updating feeder, Please wait...', false);
      var petID = FireStoreUtils().getPet(FireStoreUtils.petID);
      try {
        schedule.name = scheduleName;
        schedule.portion = portion;
        schedule.time = DateFormat.Hm().format(timeOfFeeding);
        if (schedule.id == null) {
          schedule = await FireStoreUtils().addSchedule(schedule);
        }
        await FireStoreUtils().updateSchedule(schedule);

        //pushReplacement(context, AddPetProfileScreen(pet: petID));
      } catch (e) {
        print('_updateFeeder._sendToServer $e');
        hideProgress();
        showAlertDialog(context, 'Failed', 'Couldn\'t update feeder');
      }
    } else {
      setState(() {
        _validate = AutovalidateMode.onUserInteraction;
      });
    }
  }
}
