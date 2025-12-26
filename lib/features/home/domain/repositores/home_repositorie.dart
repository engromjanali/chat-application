import 'package:chat_application/features/home/data/model/m_friend.dart';
import 'package:chat_application/features/home/data/model/m_query.dart';

abstract class IHomeRepository {
  // Future<void> addHomeNote(MFriend payload);
  // Future<void> updateHomeNote(MFriend payload);
  Future<void> deteteHomeNote(String id);
  Future<List<MFriend>> fetchHomeNote(MQuery payload);
}
