import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:file_picker/file_picker.dart';
import 'models/invitation.dart';
import 'dart:async';
import 'dart:io';

class RegisterInvitation extends StatefulWidget {
  RegisterInvitation({Key key}) : super(key: key);

  @override
  _RegisterInvitationState createState() =>  new _RegisterInvitationState();
}

class _RegisterInvitationState extends State<RegisterInvitation> {
  List<Invitation> _invitationList;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  Query _invitationQuery;
  bool _loadingPath = false;
  String _filePath;
  String _fileName;
  String _content;
  List<String> _daftarTamu = new List<String>();

  StreamSubscription<Event> _onInvitationAddedSubscription;
  StreamSubscription<Event> _onInvitationChangedSubscription;


  @override
  void initState(){
    super.initState();
    _invitationList = new List();
    _invitationQuery = _database
        .reference()
        .child("Invitations");
    _onInvitationAddedSubscription = _invitationQuery.onChildAdded.listen(onEntryAdded);
    _onInvitationChangedSubscription = _invitationQuery.onChildChanged.listen(onEntryChanged);
  }

  @override
  void dispose() {
    _onInvitationAddedSubscription.cancel();
    _onInvitationChangedSubscription.cancel();
    super.dispose();
  }

  onEntryAdded(Event event) {
    setState(() {
      _invitationList.add(Invitation.fromSnapshot(event.snapshot));
    });
  }

  onEntryChanged(Event event){
    var oldEntry = _invitationList.singleWhere((entry) {
      return entry.id == event.snapshot.key;
    });

    setState(() {
      _invitationList[_invitationList.indexOf(oldEntry)] = Invitation.fromSnapshot(event.snapshot);
    });
  }

  addNewInvitation(String namaTamu){
    Invitation invitation = new Invitation("wedding01", namaTamu, "~otw", "link-to-qr");
    _database.reference().child("Invitations").push().set(invitation.toJson());
  }

  deleteInvitation(String id, int index) {
    _database.reference().child("Invitations").child(id).remove().then((_) {
      print("Delete $id successful");
      setState(() {
        _invitationList.removeAt(index);
      });
    });
  }

  //Function to handle the click explore file button --> until the "tamu" data is parsed.
  void openFileExplorer() async {
    setState(() {
      _loadingPath = true;
    });
    try {
      _filePath = await FilePicker.getFilePath(type: FileType.any);
    } on PlatformException catch(e){
      print("Here are the error "+e.toString());
    }
    if(!mounted) return;
    setState(() {
      _loadingPath=false;
      _fileName = _filePath != null ? _filePath.split('/').last : '...';
    });
    print(_fileName);
    print(_filePath);
    _content = await read();
    parseData(_content);
  }

  void parseData(String content){
    var data = json.decode(content);
    var tamu = data["tamu"] as List;
    print(tamu.runtimeType);
    print(tamu);
    for(var i=0; i < tamu.length; i++){
      _daftarTamu.add(tamu[i]["nama"].toString());
    }
    print(_daftarTamu.runtimeType);
    //print(_daftarTamu);
    for(var j=0; j<_daftarTamu.length;j++){
      print("iterasi " + j.toString() + " " + _daftarTamu[j] + "\n");
      addNewInvitation(_daftarTamu[j]);
    }
  }

  Future<String> read() async {
    String text;
    try{
      final File file = File(_filePath.toString());
      text = await file.readAsString();
    }catch (e){
      print("couldn't read file");
    }
    return text;
  }

  Widget showInvitationList() {
    if (_invitationList.length > 0) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: _invitationList.length,
          itemBuilder: (BuildContext context, int index) {
              String id = _invitationList[index].id;
              String name = _invitationList[index].name;
            return Dismissible(
              key: Key(id),
              background: Container(color: Colors.red),
              onDismissed: (direction) async {
                deleteInvitation(id, index);
              },
              child: ListTile(
                title: Text(
                  name ?? 'default value' ,
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            );
          });
    } else {
      return Center(
          child: Text(
            "Welcome. Your list is empty",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30.0),
          ));
    }
  }


  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(30),
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(
                child: Text("Click button down below to register the Invited Guest to your wedding event!",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              ),
            ),

          ],
        ),
        Divider(),
        RaisedButton(
          child: Text("Import Invited Guest JSON File", style: TextStyle(color: Colors.white),),
          color: Colors.green,
          onPressed: (){
            openFileExplorer();
          },
        ),
        Divider(),
        showInvitationList()
      ],
    );
  }
}