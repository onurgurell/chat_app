import 'package:chat_app/models/commnctn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Communaciton>> getCommunaciton(String userId) {
    var ref = _firestore
        .collection('communication')
        .where('members', arrayContains: userId);

    return ref.snapshots().map(
          (event) =>
              event.docs.map((e) => Communaciton.fromSnapshot(e)).toList(),
        );
  }
}
