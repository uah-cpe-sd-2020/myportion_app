import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myportion_app/services/helper.dart';
import 'package:myportion_app/constants.dart';

class AddFeederScreen extends StatefulWidget {
  @override
  State createState() => _AddFeederScreenState();
}

class _AddFeederScreenState extends State<AddFeederScreen> {
  GlobalKey<FormState> _key = new GlobalKey();
  AutovalidateMode _validate = AutovalidateMode.disabled;
  String feederName;
  String modelNumber;

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
    return new Column(
      children: <Widget>[
        new Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Update Feeder',
              style: TextStyle(
                  color: Color(COLOR_PRIMARY),
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0),
            )),
        Padding(
          padding: const EdgeInsets.only(right: 40.0, left: 40.0, top: 40.0),
          child:  ConstrainedBox(
              constraints: BoxConstraints(minWidth: double.infinity),
              child: Padding(
                  padding:
                  const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
                  child: TextFormField(
                      key: Key('FeederName'),
                      validator: validateName,
                      onSaved: (String val) {
                        feederName = val;
                      },
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                      decoration: InputDecoration(
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          fillColor: Colors.white,
                          hintText: 'Feeder Name',
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                  color: Color(COLOR_PRIMARY), width: 2.0)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ))))),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 40.0, left: 40.0, top: 40.0),
          child:  ConstrainedBox(
              constraints: BoxConstraints(minWidth: double.infinity),
              child: Padding(
                  padding:
                  const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
                  child: TextFormField(
                      key: Key('ModelNumber'),
                      validator: validateSerialNumber,
                      onSaved: (String val) {
                        modelNumber = val;
                      },
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                      decoration: InputDecoration(
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          fillColor: Colors.white,
                          hintText: 'Model Number',
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                  color: Color(COLOR_PRIMARY), width: 2.0)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ))))),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 40.0, left: 40.0, top: 40.0),
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

 /* _sendToServer() async {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      showProgress(context, 'Updating feeder, Please wait...', false);
      try {
        Feeder feeder = Feeder(
            id: '',
            name: feederName,
            modelNum: modelNumber);

        /*if feeder doesn't exist currently*/
        feeder = await FireStoreUtils().addFeeder(feeder);

        /*if feeder already exists */
        feeder = await FireStoreUtils().updateFeeder(feeder);

        pushAndRemoveUntil(
            context, HomeScreen(user: MyAppState.currentUser), false);
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
  }*/
}

