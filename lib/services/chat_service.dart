import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dismov_app/models/chat_model.dart';
import 'package:dismov_app/models/message_model.dart';
// import stream_builder.dart


class ChatService {
  // Instancia de Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Método para obtener un chat por su ID
  Future<ChatModel?> getChatById(String chatId) async {
    DocumentSnapshot chatSnapshot =
        await _firestore.collection('chats').doc(chatId).get();

    if (chatSnapshot.exists) {
      return ChatModel.fromFirebase(chatSnapshot);
    } else {
      return null;
    }
  } 

  // stream para obtener todos los chats de un usuario
  Stream<List<ChatModel>> getChatsByUserIdStream(String userId) {
    return _firestore.collection('chats')
      .where(
        Filter.or(
          Filter('userId', isEqualTo: userId),
          Filter('shelterId', isEqualTo: userId)
        )
      ).snapshots().map((snapshot) => snapshot.docs.map((doc) => ChatModel.fromFirebase(doc)).toList());
  }

  // Stream para obtener todos los mensajes de un chat
  Stream<List<MessageModel>> getMessagesByChatIdStream(String chatId) {
    return _firestore.collection('chats').doc(chatId).collection('messages').orderBy('time', descending: false).snapshots().map((snapshot) => snapshot.docs.map((doc) => MessageModel.fromFirebase(doc)).toList());
  }

  // Método para ver todos los chats de un usuario
  Future<List<ChatModel>> getChatsByUserId(String userId) async {
    QuerySnapshot chatsSnapshot = await _firestore.collection('chats')
      .where(
        Filter.or(
          Filter('userId', isEqualTo: userId),
          Filter('shelterId', isEqualTo: userId)
        )
      ).get();

    return chatsSnapshot.docs.map((doc) => ChatModel.fromFirebase(doc)).toList();
  }

  // Método para agregar un nuevo chat
  Future<String> addChat(ChatModel chat) async {
    DocumentReference docRef = await _firestore.collection('chats').add(chat.toMap());
    // update the chat with the id
    await _firestore.collection('chats').doc(docRef.id).update({
      'uid': docRef.id,
    });
    return docRef.id;
  }

  // Método para actualizar la información de un chat
  Future<void> updateChat(ChatModel chat) async {
    await _firestore.collection('chats').doc(chat.id).update(chat.toMap());
  }

  // Método para revisar si existe un chat entre dos usuarios y una mascota
  Future<ChatModel?> checkChat(String userId, String shelterId, String petId) async {
    QuerySnapshot chatsSnapshot = await _firestore.collection('chats')
      .where('userId', isEqualTo: userId)
      .where('shelterId', isEqualTo: shelterId)
      .where('petId', isEqualTo: petId)
      .get();

    if (chatsSnapshot.docs.isNotEmpty) {
      return ChatModel.fromFirebase(chatsSnapshot.docs.first);
    } else {
      return null;
    }
  }

  Future<DocumentReference> createChat(ChatModel chat) async {
    return _firestore.collection('chats').add(chat.toMap());
  }

  // Metodo para añadir un mensaje a un chat
  Future<void> addMessageToChat(String chatId, MessageModel message) async {
    // iniciar una transacción para escribir el mensaje y actualizar el recentMessage
    WriteBatch batch = _firestore.batch();
    batch.set(_firestore.collection('chats').doc(chatId).collection('messages').doc(), {
      'content': message.content,
      'imageURL': message.imageURL,
      'senderId': message.senderId,
      'senderName': message.senderName,
      'time': message.time,
    });
    batch.update(_firestore.collection('chats').doc(chatId), {
      'recentMessageContent': message.content,
      'recentMessageSenderId': message.senderId,
      'recentMessageTime': message.time,
      }
    );
    await batch.commit();
  }

  // Método para obtener todos los mensajes de un chat
  Future<List<MessageModel>> getMessagesByChatId(String chatId) async {
    QuerySnapshot messagesSnapshot = await _firestore.collection('chats').doc(chatId).collection('messages').orderBy('time').get();
    return messagesSnapshot.docs.map((doc) => MessageModel.fromFirebase(doc)).toList();
  }
}