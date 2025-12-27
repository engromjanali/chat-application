import 'package:chat_application/features/home/domain/entryes/e_message.dart';

class MMessage extends EMessage {
  const MMessage({
    required super.messageId,
    required super.text,
    required super.sender,
    required super.time,
    required super.files,
  });

  factory MMessage.fromJson(String id, Map<dynamic, dynamic> json) {
    return MMessage(
      messageId: id,
      text: json['text'] ?? '',
      sender: json['sender'] ?? '',
      time: json['time'] != null ? DateTime.parse(json['time']) : null,
      files: json['files'] != null
          ? (json['files'] as List<dynamic>)
                .map((val) => val.toString())
                .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "text": text,
      "sender": sender,
      "time": time?.toIso8601String(),
      "files": files.toList(),
    };
  }
}

// class MMessage {
//   final String messageId;
//   final String text;
//   final String sender;
//   final DateTime? time;

//   MMessage({
//     required this.messageId,
//     required this.text,
//     required this.sender,
//     required this.time,
//   });

//   factory MMessage.fromJson(String id, Map<dynamic, dynamic> json) {
//     return MMessage(
//       messageId: id,
//       text: json['text'] ?? '',
//       sender: json['sender'] ?? '',
//       time: DateTime.parse(json['time']),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       "messageId": messageId,
//       "text": text,
//       "sender": sender,
//       "time": time,
//     };
//   }
// }
