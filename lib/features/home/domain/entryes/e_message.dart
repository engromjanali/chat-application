import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class EMessage {
  final String messageId;
  final String text;
  final List<String> files;
  final String sender;
  final DateTime? time;

  const EMessage({
    required this.messageId,
    required this.text,
    required this.files,
    required this.sender,
    required this.time,
  });
}
