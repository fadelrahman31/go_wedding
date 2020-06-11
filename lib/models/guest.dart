import 'package:firebase_database/firebase_database.dart';

class Guest {
  String _id;
  String _id_wedding;
  String _name;
  String _arriving_hour;
  String _souvenir;
  String _additional;
  String _photo;

  Guest(this._id, this._id_wedding, this._name, this._arriving_hour, this._souvenir, this._additional, this._photo);
 
  Guest.map(dynamic obj) {
    this._id = obj['id'];
    this._id_wedding = obj['id_wedding'];
    this._name = obj['name'];
    this._arriving_hour = obj['arriving_hour']; 
    this._souvenir = obj['souvenir'];
    this._additional = obj['additional'];
    this._photo = obj['photo'];
  }
 
  String get id => _id;
  String get idwedding => _id_wedding;
  String get name => _name;
  String get arrivinghour => _arriving_hour;
  String get souvenir => _souvenir;
  String get additional => _additional;
  String get qrpath => _photo;
 
  Guest.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _id_wedding = snapshot.value['id_wedding'];
    _name = snapshot.value['name'];
    _arriving_hour = snapshot.value['arriving_hour'];
    _additional = snapshot.value['additional'];
    _additional = snapshot.value['additional'];
    _photo = snapshot.value['photo'];
  }
}