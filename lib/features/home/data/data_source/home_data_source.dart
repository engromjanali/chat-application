import 'package:chat_application/features/home/data/model/m_friend.dart';
import 'package:chat_application/features/home/data/model/m_query.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IHomeDataSource {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  
  // Future<void> addHomeNote(MHome payload);
  // Future<void> updateHomeNote(MHome payload);
  Future<void> deteteHomeNote(String id);
  Future<List<MFriend>> fetchHomeNote(MQuery payload);
}
