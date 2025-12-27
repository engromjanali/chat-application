import 'package:chat_application/features/home/domain/entryes/e_message.dart';
import 'package:chat_application/features/home/domain/entryes/e_query.dart';
import 'package:chat_application/features/home/data/model/m_friend.dart';

abstract class IHomeRepository {
  // Future<void> addHomeFriend(MFriend payload);
  // Future<void> updateHomeFriend(MFriend payload);
  Future<void> deteteHomeFriend(String id);
  Future<List<MFriend>> fetchHomeFriend(EQuery payload);
  Future<void> sendMessage(EMessage payload);
}
