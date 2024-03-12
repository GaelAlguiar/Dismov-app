import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> getUser() async{
  List user = [];
  CollectionReference collectionReferenceUser = db.collection('users');

  QuerySnapshot queryUser = await collectionReferenceUser.get();

  queryUser.docs.forEach((documento){
    user.add(documento.data());
  });

  return user;
}