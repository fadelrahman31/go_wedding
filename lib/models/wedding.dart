import 'package:firebase_database/firebase_database.dart';

class Wedding {
  String _id;
  String _owner;
  String _date;
  String _location;
  String _hour;
  String _created_at;

  Wedding(this._owner, this._date, this._hour, this._location, this._created_at);
 
  Wedding.map(dynamic obj) {
    this._owner = obj['owner'];
    this._date = obj['date'];
    this._hour = obj['hour'];
    this._location = obj['location'];
    this._created_at = obj['created_at'];
  }
 
  String get id => _id;
  String get owner => _owner;
  String get date => _date;
  String get hour => _hour;
  String get location => _location;
  String get createdat => _created_at;
 
  Wedding.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _owner = snapshot.value['owner'];
    _date = snapshot.value['date'];
    _hour = snapshot.value['hour'];
    _location = snapshot.value['location'];
    _created_at = snapshot.value['created_at'];
  }

  toJson() {
    return {
      "owner": owner,
      "date": date,
      "hour": hour,
      "location": location,
      "created_at": createdat
    };
  }
}