import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myportion_app/constants.dart';
import 'package:myportion_app/main.dart';
import 'package:myportion_app/model/Pet.dart';
import 'package:myportion_app/services/helper.dart';
import 'package:myportion_app/services/FirestoreUtils.dart';
import 'package:myportion_app/ui/addPet/AddPetProfileScreen.dart';
import 'package:myportion_app/ui/home/HomeScreen.dart';

class PetListScreen extends StatefulWidget {
  @override
  State createState() => _PetListScreenState();
}

class _PetListScreenState extends State<PetListScreen> {
  _PetListScreenState();

  GlobalKey<FormState> _key = new GlobalKey();
  AutovalidateMode _validate = AutovalidateMode.disabled;

  addPet() async {
    pushReplacement(context, new AddPetProfileScreen(pet: new Pet()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(COLOR_PRIMARY),
        title: Text('List Of Pets'),
        leading: IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () async {
            pushReplacement(
                context, HomeScreen(key: null, user: MyAppState.currentUser));
          },
        ),
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
          height: 670,
          child: Scaffold(
            body: FutureBuilder<List>(
              future: FireStoreUtils().getPetList(),
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
                                  pushReplacement(context,
                                      new AddPetProfileScreen(pet: item));
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
                heroTag: "addPet",
                onPressed: addPet,
                child: new Icon(Icons.add)),
          ),
        ),
      ],
    );
  }
}
