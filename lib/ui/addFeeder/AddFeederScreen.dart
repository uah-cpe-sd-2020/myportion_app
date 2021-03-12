import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myportion_app/services/FirestoreUtils.dart';
import 'package:myportion_app/services/helper.dart';
import 'package:myportion_app/constants.dart';
import 'package:myportion_app/model/Feeder.dart';
import 'package:myportion_app/ui/FeederList/FeederListScreen.dart';
import 'package:myportion_app/ui/home/HomeScreen.dart';

import 'package:myportion_app/main.dart';

class AddFeederScreen extends StatefulWidget {
  final Feeder feeder;

  AddFeederScreen({@required this.feeder});
  @override
  State createState() =>
      _AddFeederScreenState(feeder, feeder.name, feeder.serialNum);
}

class _AddFeederScreenState extends State<AddFeederScreen> {
  GlobalKey<FormState> _key = new GlobalKey();
  AutovalidateMode _validate = AutovalidateMode.disabled;
  Feeder feeder;
  String feederName;
  String serialNumber;

  _AddFeederScreenState(this.feeder, this.feederName, this.serialNumber);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(COLOR_PRIMARY),
        title: Text('Update Feeder'),
        leading: IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () async {
            Feeder temp = await FireStoreUtils().getFeeder(feeder.id);
            if (temp.id == '') {
              await FireStoreUtils().removeFeeder(feeder);
            }
            pushReplacement(context, FeederListScreen());
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
                      key: Key('FeederName'),
                      validator: validateName,
                      onSaved: (String val) {
                        feederName = val;
                      },
                      initialValue: feederName,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).nextFocus(),
                      decoration: InputDecoration(
                          labelText: 'Feeder Name',
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
                  child: TextFormField(
                      key: Key('SerialNumber'),
                      validator: validateSerialNumber,
                      onSaved: (String val) {
                        serialNumber = val;
                      },
                      initialValue: serialNumber,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).nextFocus(),
                      decoration: InputDecoration(
                          labelText: 'Serial Number',
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
      try {
        feeder.name = feederName;
        feeder.modelType = "Prototype";
        feeder.serialNum = serialNumber;
        await FireStoreUtils().updateFeeder(feeder);

        pushAndRemoveUntil(context, FeederListScreen(), false);
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
