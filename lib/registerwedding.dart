import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:go_wedding/models/wedding.dart';
import 'package:random_string/random_string.dart';
import 'dart:async';


class WeddingPage extends StatefulWidget {
  WeddingPage({Key key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new _WeddingPageState();
}

class _WeddingPageState extends State<WeddingPage> {
  List<Wedding> _weddingList;

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final _dateInputController = TextEditingController();
  final _locationInputController = TextEditingController();
  final _ownerInputController = TextEditingController();
  final _hourInputController = TextEditingController();
  StreamSubscription<Event> _onWeddingAddedSubscription;
  StreamSubscription<Event> _onWeddingChangedSubscription;

  Query _weddingQuery;


  @override
  void initState() {
    super.initState();

    _weddingList = new List();
    _weddingQuery = _database
        .reference()
        .child("Weddings");
    _onWeddingAddedSubscription = _weddingQuery.onChildAdded.listen(onEntryAdded);
    _onWeddingChangedSubscription =
        _weddingQuery.onChildChanged.listen(onEntryChanged);
  }

  @override
  void dispose() {
    _onWeddingAddedSubscription.cancel();
    _onWeddingChangedSubscription.cancel();
    super.dispose();
  }

  onEntryChanged(Event event) {
    var oldEntry = _weddingList.singleWhere((entry) {
      return entry.id == event.snapshot.key;
    });

    setState(() {
      _weddingList[_weddingList.indexOf(oldEntry)] =
          Wedding.fromSnapshot(event.snapshot);
    });
  }

  onEntryAdded(Event event) {
    setState(() {
      _weddingList.add(Wedding.fromSnapshot(event.snapshot));
    });
  }

  addNewwedding(String owner, String date, String hour, String location) {
    Wedding wedding = new Wedding(randomAlphaNumeric(20), owner, date, hour, location, DateTime.now().toString());
    _database.reference().child("Weddings").push().set(wedding.toJson());
  }

  deletewedding(String id, int index) {
    _database.reference().child("Weddings").child(id).remove().then((_) {
      print("Delete $id successful");
      setState(() {
        _weddingList.removeAt(index);
      });
    });
  }

showAddweddingDialog(BuildContext context) async {
    _dateInputController.clear();
    _hourInputController.clear();
    _locationInputController.clear();
    _ownerInputController.clear();
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new Column(
              children: <Widget>[
                new Expanded(
                    child: new TextField(
                  controller: _ownerInputController,
                  autofocus: true,
                  decoration: new InputDecoration(
                    labelText: 'Wedding Title / Owner',
                  ),
                )),
                new Expanded(
                    child: new TextField(
                  controller: _locationInputController,
                  autofocus: true,
                  decoration: new InputDecoration(
                    labelText: 'Lokasi Wedding',
                  ),
                )),
                new Expanded(
                    child: new TextField(
                  controller: _dateInputController,
                  autofocus: true,
                  decoration: new InputDecoration(
                    labelText: 'Tanggal Pelaksanaan',
                  ),
                )),
                new Expanded(
                    child: new TextField(
                  controller: _hourInputController,
                  autofocus: true,
                  decoration: new InputDecoration(
                    labelText: 'Waktu Pelaksanaan',
                  ),
                ))
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              new FlatButton(
                  child: const Text('Save'),
                  onPressed: () {
                    addNewwedding(_ownerInputController.text.toString(), _locationInputController.text.toString(), _dateInputController.text.toString(), _hourInputController.text.toString());
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }
  // showAddweddingDialog(BuildContext context) async {
  //   _dateInputController.clear();
  //   _hourInputController.clear();
  //   _locationInputController.clear();
  //   _ownerInputController.clear();
  //   await showDialog<String>(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           content: new Row(
  //             children: <Widget>[
  //               new Expanded(
  //                   child: new TextField(
  //                 controller: _ownerInputController,
  //                 autofocus: true,
  //                 decoration: new InputDecoration(
  //                   labelText: 'Wedding Title / Owner',
  //                 ),
  //               )),
  //               new Expanded(
  //                   child: new TextField(
  //                 controller: _locationInputController,
  //                 autofocus: true,
  //                 decoration: new InputDecoration(
  //                   labelText: 'Lokasi Wedding',
  //                 ),
  //               )),
  //               new Expanded(
  //                   child: new TextField(
  //                 controller: _dateInputController,
  //                 autofocus: true,
  //                 decoration: new InputDecoration(
  //                   labelText: 'Tanggal Pelaksanaan',
  //                 ),
  //               )),
  //               new Expanded(
  //                   child: new TextField(
  //                 controller: _hourInputController,
  //                 autofocus: true,
  //                 decoration: new InputDecoration(
  //                   labelText: 'Waktu Pelaksanaan',
  //                 ),
  //               ))
  //             ],
  //           ),
  //           actions: <Widget>[
  //             new FlatButton(
  //                 child: const Text('Cancel'),
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                 }),
  //             new FlatButton(
  //                 child: const Text('Save'),
  //                 onPressed: () {
  //                   addNewwedding(_ownerInputController.text.toString(), _locationInputController.text.toString(), _dateInputController.text.toString(), _hourInputController.text.toString());
  //                   Navigator.pop(context);
  //                 })
  //           ],
  //         );
  //       });
  // }

  Widget showweddingList() {
    if (_weddingList.length > 0) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: _weddingList.length,
          itemBuilder: (BuildContext context, int index) {
            String id = _weddingList[index].id;
            String owner = _weddingList[index].owner;
            String date = _weddingList[index].date;
            String location = _weddingList[index].location;
            String created_at = _weddingList[index].createdat;
            return Dismissible(
              key: Key(id),
              background: Container(color: Colors.red),
              onDismissed: (direction) async {
                deletewedding(id, index);
              },
              child: ListTile(
                title: Text(
                  owner ?? 'default value',
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
    return new Scaffold(
        body: showweddingList(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showAddweddingDialog(context);
          },
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ));
  }
}