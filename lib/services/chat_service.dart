import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/chat_model.dart';
import '../models/message_model.dart';

class ChatService {
  // Instancia de Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Método para obtener un chat por su ID
  Future<ChatModel?> getChatById(String chatId) async {
    DocumentSnapshot chatSnapshot =
        await _firestore.collection('chats').doc(chatId).get();

    if (chatSnapshot.exists) {
      return ChatModel.fromMap(chatSnapshot.data()! as Map<String, dynamic>);
    } else {
      return null;
    }
  } 

  // Método para ver todos los chats de un usuario
  Future<List<ChatModel>> getChatsByUserId(String userId) async {
    QuerySnapshot chatsSnapshot = await _firestore.collection('chats')
        .where('users', arrayContains: userId)
        .get();
    return chatsSnapshot.docs.map((doc) => ChatModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
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


  // Metodo para añadir un mensaje a un chat
  Future<void> addMessageToChat(String chatId, MessageModel message) async {
    // iniciar una transacción para escribir el mensaje y actualizar el recentMessage
    WriteBatch batch = _firestore.batch();
    batch.set(_firestore.collection('chats').doc(chatId).collection('messages').doc(), message.toMap());
    batch.update(_firestore.collection('chats').doc(chatId), {'recentMessage': message.content});
    await batch.commit();
  }

  // Método para obtener todos los mensajes de un chat
  Future<List<MessageModel>> getMessagesByChatId(String chatId) async {
    QuerySnapshot messagesSnapshot = await _firestore.collection('chats').doc(chatId).collection('messages').get();
    return messagesSnapshot.docs.map((doc) => MessageModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }



}