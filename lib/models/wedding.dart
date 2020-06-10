import 'package:firebase_database/firebase_database.dart';

class Wedding {
  String _id;
  String _owner;
  String _date;
  String _location;
  String _created_at;

  Wedding(this._id, this._owner, this._date, this._location, this._created_at);
 
  Wedding.map(dynamic obj) {
    this._id = obj['id'];
    this._owner = obj['owner'];
    this._date = obj['date'];
    this._location = obj['location'];
    this._created_at = obj['created_at'];
  }
 
  String get id => _id;
  String get owner => _owner;
  String get date => _date;
  String get location => _location;
  String get createdat => _created_at;
 
  Wedding.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _owner = snapshot.value['owner'];
    _date = snapshot.value['date'];
    _location = snapshot.value['location'];
    _created_at = snapshot.value['crated_at'];
  }

  toJson() {
    return {
      "id": id,
      "owner": owner,
      "date": date,
      "location": location,
      "crated_at": createdat
    };
  }
}