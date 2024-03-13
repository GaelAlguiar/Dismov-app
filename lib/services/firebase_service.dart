import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> getUser(String? email) async {
  List user = [];
  CollectionReference collectionReferenceUser = db.collection('users');

  QuerySnapshot queryUser =
      await collectionReferenceUser.where("email", isEqualTo: email).get();

  for (var documento in queryUser.docs) {
    user.add(documento.data());
  }

  return user;
}

//Function to save name and email in db
Future<void> addPeople(String name, String email) async {
  await db.collection("userInfo").add({"name": name, "email": email});
}
