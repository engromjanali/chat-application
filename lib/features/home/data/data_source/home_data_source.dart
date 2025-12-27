import 'package:chat_application/features/home/data/model/m_friend.dart';
import 'package:chat_application/features/home/domain/entryes/e_message.dart';
import 'package:chat_application/features/home/domain/entryes/e_query.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IHomeDataSource {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  // Future<void> addHomeFriend(MHome payload);
  // Future<void> updateHomeFriend(MHome payload);
  Future<void> deteteHomeFriend(String id);
  Future<List<MFriend>> fetchHomeFriend(EQuery payload);
  Future<void> sendMessage(EMessage payload);
}
