import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:file_picker/file_picker.dart';
import 'models/invitation.dart';
import 'pickfile.dart';

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

  @override
  void initState(){
    super.initState();
    _invitationList = new List();
    _invitationQuery = _database.reference().child("Invitations");
  }


  void _openFileExplorer() async {
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
          child: Text("Import Invited Guest JSON File"),
          color: Colors.green,
          onPressed: (){
//            Navigator.of(context).push(
//              MaterialPageRoute(
//                builder: (context){
//                  return FilePickerDemo();
//                }
//              )
//            );
            _openFileExplorer();
          },
        )
      ],
    );
  }
}