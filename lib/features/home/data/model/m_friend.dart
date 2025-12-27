
import 'package:chat_application/features/home/domain/entryes/e_firend.dart';

class MFriend extends EFriend {
  const MFriend({
    required super.userId,
    super.name,
    super.lastMessage,
    super.time,
    super.unreadMCount,
    super.pImage,
  });

  /// From JSON / Firebase
  factory MFriend.fromJson(Map<String, dynamic> json) {
    return MFriend(
      userId: json['userId'] ?? '',
      name: json['name'],
      lastMessage: json['lastMessage'],
      time: json['time'] is String
          ? DateTime.tryParse(json['time'])
          : json['time'] is DateTime
              ? json['time']
              : null,
      unreadMCount: json['unreadMCount'] ?? 0,
      pImage: json['pImage'],
    );
  }

  /// To JSON / Firebase
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'lastMessage': lastMessage,
      'time': time?.toIso8601String(),
      'unreadMCount': unreadMCount,
      'pImage': pImage,
    };
  }
}


// class MFriend {
//   final String userId;
//   final String? name;
//   final String? lastMessage;
//   final DateTime? time;
//   final int? unreadMCount;
//   final String? pImage;

//   MFriend({
//     required this.userId,
//     this.name,
//     this.lastMessage,
//     this.time,
//     this.unreadMCount,
//     this.pImage,
//   });

//   // Factory constructor to create a MFriend from JSON (Map)
//   factory MFriend.fromJson(Map<String, dynamic> json) {
//     return MFriend(
//       userId: json['userId'] ?? '',
//       name: json['name'] ?? '',
//       lastMessage: json['lastMessage'] ?? '',
//       // Handles both String and Timestamp formats for the date
//       time: json['time'] is String
//           ? DateTime.parse(json['time'])
//           : (json['time'] as DateTime),
//       unreadMCount: json['unreadMCount'] ?? 0,
//       pImage: json['pImage'] ?? '',
//     );
//   }

//   // Method to convert MFriend instance to JSON (Map)
//   Map<String, dynamic> toJson() {
//     return {
//       'userId': userId,
//       'name': name,
//       'lastMessage': lastMessage,
//       'time': time?.toIso8601String(),
//       'unreadMCount': unreadMCount,
//       'pImage': pImage,
//     };
//   }
// }
