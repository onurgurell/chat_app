import 'package:cloud_firestore/cloud_firestore.dart';

class Communaciton {
  String id;
  String name;
  String profileImage;
  String displayMessage;
  Communaciton(
      {required this.id,
      required this.name,
      required this.profileImage,
      required this.displayMessage});

  factory Communaciton.fromSnapshot(DocumentSnapshot snapshot) {
    return Communaciton(
      id: snapshot.id,
      name: 'ONUR',
      profileImage:
          'https://upload.wikimedia.org/wikipedia/tr/6/67/Avengersendgame.jpg',
      displayMessage: snapshot['displayMessage'],
    );
  }
}
