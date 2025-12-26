class MMessage {
  final String messageId;
  final String text;
  final String sender;
  final DateTime? time;

  MMessage({
    required this.messageId,
    required this.text,
    required this.sender,
    required this.time,
  });

  factory MMessage.fromJson(String id, Map<dynamic, dynamic> json) {
    return MMessage(
      messageId: id,
      text: json['text'] ?? '',
      sender: json['sender'] ?? '',
      time: DateTime.parse(json['time']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "messageId": messageId,
      "text": text,
      "sender": sender,
      "time": time,
    };
  }
}
