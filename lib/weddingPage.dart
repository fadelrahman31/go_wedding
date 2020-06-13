import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:io';
import 'dart:async';
import 'models/wedding.dart';
import 'models/invitation.dart';

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

  Query _invitationQuery;
  Query _weddingQuery;

  StreamSubscription<Event> _onWeddingAddedSubscription;
  StreamSubscription<Event> _onWeddingChangedSubscription;

  StreamSubscription<Event> _onInvitationAddedSubscription;
  StreamSubscription<Event> _onInvitationChangedSubscription;


  @override
  void initState() {
    String aidi = widget.requiredID;
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
      .child("Invitations");
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

  @override
  Widget build(BuildContext context) {
    print(widget.requiredID);
    return new Scaffold(
      body: showWeddingData(),
    );
  }
}