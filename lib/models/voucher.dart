import 'package:firebase_database/firebase_database.dart';

class Voucher {
  String _id;
  String _id_wedding;
  DateTime _printed_at;

  Voucher(this._id, this._id_wedding, this._printed_at);
 
  Voucher.map(dynamic obj) {
    this._id = obj['id'];
    this._id_wedding = obj['id_wedding'];
    this._printed_at = obj['printed_at'];;
  }
 
  String get id => _id;
  String get idwedding => _id_wedding;
  DateTime get printedat => _printed_at;
 
  Voucher.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _id_wedding = snapshot.value['id_wedding'];
    _printed_at = snapshot.value['printed_at'];
  }
}