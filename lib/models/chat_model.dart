class ChatModel {
  String id;
  List<String> participantsIds;
  String? recentMessageContent;
  String? recentMessageSenderName;
  int? recentMessageTime;

  ChatModel({
    required this.id,
    required this.participantsIds,
    this.recentMessageContent,
    this.recentMessageSenderName,
    this.recentMessageTime,
  });

  // Método para convertir un objeto de chat a un mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'participantsIds': participantsIds,
      'recentMessageContent': recentMessageContent,
      'recentMessageSenderName': recentMessageSenderName,
      'recentMessageTime': recentMessageTime,
    };
  }

  // Método para crear un objeto de chat desde un mapa
  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      id: map['id'],
      participantsIds: List<String>.from(map['participantsIds']),
      recentMessageContent: map['recentMessageContent'],
      recentMessageSenderName: map['recentMessageSenderName'],
      recentMessageTime: map['recentMessageTime'],
    );
  }
}
