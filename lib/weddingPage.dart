import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:io';
import 'dart:async';
import 'models/wedding.dart';
import 'models/invitation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:random_string/random_string.dart';
import 'dart:convert';

class WeddingDetailsPage extends StatefulWidget {
  final String requiredID;

  WeddingDetailsPage(this.requiredID);

  //WeddingPage({Key key, @required this.requiredID,}): super(key: key);

  @override
  _WeddingDetailsPageState createState() => new _WeddingDetailsPageState();
}

class _WeddingDetailsPageState extends State<WeddingDetailsPage> {
  List<Wedding> _weddingList;
  List<Invitation> _invitationList;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  bool _loadingPath = false;
  String _filePath;
  String _fileName;
  String _content;
  List<String> _daftarTamu = new List<String>();

  Query _invitationQuery;
  Query _weddingQuery;

  StreamSubscription<Event> _onWeddingAddedSubscription;
  StreamSubscription<Event> _onWeddingChangedSubscription;

  StreamSubscription<Event> _onInvitationAddedSubscription;
  StreamSubscription<Event> _onInvitationChangedSubscription;


  @override
  void initState() {
    super.initState();
    _weddingList = new List();
    _weddingQuery = _database
      .reference()
      .child("Weddings")
      .orderByChild("weddingID")
      .equalTo(widget.requiredID);
      //.equalTo(widget.requiredID);
    _onWeddingAddedSubscription = _weddingQuery.onChildAdded.listen(onEntryWeddingAdded);
    _onWeddingChangedSubscription = _weddingQuery.onChildChanged.listen(onEntryWeddingChanged);


    _invitationList = new List();
    _invitationQuery = _database
      .reference()
      .child("Invitations")
      .orderByChild("id_wedding")
      .equalTo(widget.requiredID);
    _onInvitationAddedSubscription = _invitationQuery.onChildAdded.listen(onEntryInvitationAdded);
    _onInvitationChangedSubscription = _invitationQuery.onChildChanged.listen(onEntryInvitationChanged);

  }

  onEntryWeddingChanged(Event event){
    var oldEntry = _weddingList.singleWhere((entry) {
      return entry.id == event.snapshot.key;
    });

    setState(() {
      _weddingList[_weddingList.indexOf(oldEntry)] =
          Wedding.fromSnapshot(event.snapshot);
    });
  }

  onEntryWeddingAdded(Event event){
    setState(() {
      _weddingList.add(Wedding.fromSnapshot(event.snapshot));
    });
  }

  onEntryInvitationChanged(Event event){
    var oldEntry = _invitationList.singleWhere((entry) {
      return entry.id == event.snapshot.key;
    });

    setState(() {
      _invitationList[_invitationList.indexOf(oldEntry)] = Invitation.fromSnapshot(event.snapshot);
    });
  }

  onEntryInvitationAdded(Event event){
    setState(() {
      _invitationList.add(Invitation.fromSnapshot(event.snapshot));
    });
  }

  addNewInvitation(String namaTamu){
    Invitation invitation = new Invitation(randomAlphaNumeric(20),widget.requiredID, namaTamu, "~otw", "link-to-qr");
    _database.reference().child("Invitations").push().set(invitation.toJson());
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



  Widget weddingAccessPage(){
    return Column(
      children: <Widget>[
        AppBar(
          title: Text("Manage Wedding Event", style: TextStyle(fontWeight: FontWeight.bold),),
        ),
        showWeddingData(),
        ButtonTheme(
          minWidth: MediaQuery.of(context).size.width - (0.25 * MediaQuery.of(context).size.width),
          child: RaisedButton(
            child: Text("Scan QR", style: TextStyle(color: Colors.white)),
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(25.0)
            ),
            onPressed: (){},
          ),
        ),
        ButtonTheme(
          minWidth: MediaQuery.of(context).size.width - (0.25 * MediaQuery.of(context).size.width),
          child: RaisedButton(
            child: Text("Search by Name", style: TextStyle(color: Colors.white)),
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(25.0)
            ),
            onPressed: (){},
          ),
        ),
        ButtonTheme(
          minWidth: MediaQuery.of(context).size.width - (0.25 * MediaQuery.of(context).size.width),
          child: RaisedButton(
            child: Text("View Report", style: TextStyle(color: Colors.white)),
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(25.0)
            ),
            onPressed: (){},
          ),
        ),
        ButtonTheme(
          minWidth: MediaQuery.of(context).size.width - (0.25 * MediaQuery.of(context).size.width),
          child: RaisedButton(
            child: Text("Import Invited Guest JSON File", style: TextStyle(color: Colors.white)),
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(25.0)
            ),
            onPressed: (){
              openFileExplorer();
            },
          ),
        ),
        Expanded(
          child: showInvitationList(),
        )
      ],
    );
  }

  Widget showWeddingData(){
    if(_weddingList.length > 0) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: _weddingList.length,
        itemBuilder: (BuildContext context, int index) {
          String id = _weddingList[index].id;
          //String id = widget.id;
          String owner = _weddingList[index].owner;
          String date = _weddingList[index].date;
          String location = _weddingList[index].location;
          String created_at = _weddingList[index].createdat;
          String ketOwner = "Pernikahan " + owner;
          String ketLocation = "Lokasi: " + location;
          String ketDate = "Waktu: " + date;
          String ketCreated = "Dibuat pada: " + created_at;
          return Dismissible(
            key: Key(id),
            background: Container(color: Colors.red,),
            child: Card(
              elevation: 15.0,
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(8.0)
              ),
              margin: EdgeInsets.all(15.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    contentPadding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    title: Text(ketOwner ?? "default value", style: TextStyle(fontWeight: FontWeight.bold),),
                    subtitle: Text(ketDate ?? "null value"),
                  ),
                  Divider(),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(30, 0, 30, 5),
                        child: Text(ketLocation, style: TextStyle(fontWeight: FontWeight.bold),),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(30, 0, 30, 20),
                        child: Text(ketCreated, style: TextStyle(fontStyle: FontStyle.italic),),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
      },
      );
    } else {
      return Center(
        child: Text("Welcome, the wedding data is empty", textAlign: TextAlign.center,style: TextStyle(fontSize: 30.0),),
      );
    }
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
    print(widget.requiredID);
    return new Scaffold(
      body: weddingAccessPage(),
    );
  }
}