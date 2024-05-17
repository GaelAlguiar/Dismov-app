import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  String id;
  String petId;
  String petName;
  String petImageURL;
  String shelterId;
  String shelterName;
  String shelterImageURL;
  String userId;
  String userName;
  String userImageURL;
  String conversationStatus;
  String? recentMessageContent;
  String? recentMessageSenderId;
  int? recentMessageTime;

  ChatModel({
    required this.id,
    required this.petId,
    required this.petName,
    required this.petImageURL,
    required this.shelterId,
    required this.shelterName,
    required this.shelterImageURL,
    required this.userId,
    required this.userName,
    required this.userImageURL,
    required this.conversationStatus,
    this.recentMessageContent,
    this.recentMessageSenderId,
    this.recentMessageTime,
  });

  // Método para convertir un objeto de chat a un mapa
  Map<String, dynamic> toMap() {
    return {
      'petId': petId,
      'petName': petName,
      'petImageURL': petImageURL,
      'shelterId': shelterId,
      'shelterName': shelterName,
      'shelterImageURL': shelterImageURL,
      'userId': userId,
      'userName': userName,
      'userImageURL': userImageURL,
      'conversationStatus': conversationStatus,
      'recentMessageContent': recentMessageContent,
      'recentMessageSenderName': recentMessageSenderId,
      'recentMessageTime': recentMessageTime,
    };
  }

  // Método para crear un objeto de chat desde un mapa
  factory ChatModel.fromFirebase(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return ChatModel(
      id: doc.id,
      petId: map['petId'],
      petName: map['petName'],
      petImageURL: map['petImageURL'],
      shelterId: map['shelterId'],
      shelterName: map['shelterName'],
      shelterImageURL: map['shelterImageURL'],
      userId: map['userId'],
      userName: map['userName'],
      userImageURL: map['userImageURL'],
      conversationStatus: map['conversationStatus'],
      recentMessageContent: map['recentMessageContent'],
      recentMessageSenderId: map['recentMessageSenderId'],
      recentMessageTime: map['recentMessageTime'],
    );
  }
}
