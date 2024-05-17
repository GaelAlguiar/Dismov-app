import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String id;
  String content;
  String? imageURL;
  String senderId;
  String senderName;
  int time;

  MessageModel({
    required this.id,
    required this.content,
    this.imageURL,
    required this.senderId,
    required this.senderName,
    required this.time,
  });

  // Método para convertir un objeto de mensaje a un mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'imageURL': imageURL,
      'senderId': senderId,
      'senderName': senderName,
      'time': time,
    };
  }

  // Método para crear un objeto de mensaje desde un mapa
  factory MessageModel.fromFirebase(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;  
    // convert time strint to int
    return MessageModel(
      id: doc.id,
      content: map['content'] ?? '',
      imageURL: map['imageURL'] ?? '',
      senderId: map['senderId'] ?? '',
      senderName: map['senderName'] ?? '',
      time: int.parse((map['time'] ?? '').toString()),
    );
  }
}