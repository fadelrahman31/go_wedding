import 'package:firebase_database/firebase_database.dart';

class Invitation {
  String _id;
  String _id_wedding;
  String _name;
  String _additional;
  String _qr_path;

  Invitation(this._id, this._id_wedding, this._name, this._additional, this._qr_path);
 
  Invitation.map(dynamic obj) {
    this._id = obj['id'];
    this._id_wedding = obj['id_wedding'];
    this._name = obj['name'];
    this._additional = obj['additional'];
    this._qr_path = obj['qr_path'];
  }
 
  String get id => _id;
  String get idwedding => _id_wedding;
  String get name => _name;
  String get additional => _additional;
  String get qrpath => _qr_path;
 
  Invitation.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _id_wedding = snapshot.value['id_wedding'];
    _name = snapshot.value['name'];
    _additional = snapshot.value['additional'];
    _qr_path = snapshot.value['qr_path'];
  }

  toJson() {
    return {
      "id": id,
      "id_wedding": idwedding,
      "name": name,
      "additional":additional,
      "qr_path": qrpath
    };
  }
}