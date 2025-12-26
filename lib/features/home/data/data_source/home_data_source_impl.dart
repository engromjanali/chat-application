import 'package:chat_application/core/constants/default_values.dart';
import 'package:chat_application/core/constants/keys.dart';
import 'package:chat_application/core/functions/f_is_null.dart';
import 'package:chat_application/core/functions/f_printer.dart';
import 'package:chat_application/features/home/data/data_source/home_data_source.dart';
import 'package:chat_application/features/home/data/model/m_friend.dart';
import 'package:chat_application/features/home/data/model/m_query.dart';
import 'package:chat_application/features/profile/controllers/c_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

class HomeDatasourceImpl extends IHomeDataSource {
  CProfile cProfile = Get.find<CProfile>();

  // @override
  // Future<void> addHomeNote(MFriend payload) async {
  //   await firebaseFirestore
  //       .collection(PKeys.secretNote)
  //       .doc(cProfile.uid)
  //       .collection(PKeys.secretNote)
  //       .doc(payload.userId)
  //       .set((payload.toJson()));
  // }

  @override
  Future<void> deteteHomeNote(String id) async {
    await firebaseFirestore
        .collection(PKeys.secretNote)
        .doc(cProfile.uid)
        .collection(PKeys.secretNote)
        .doc(id)
        .delete();
  }

  @override
  Future<List<MFriend>> fetchHomeNote(MQuery payload) async {
    List<MFriend> list = [];
    Query query = FirebaseFirestore.instance
        .collection(PKeys.secretNote)
        .doc(cProfile.uid)
        .collection(PKeys.secretNote)
        .orderBy("id", descending: true);

    if ((payload.isLoadNext ?? true) && isNotNull(payload.lastEid)) {
      query = query
          .startAfter([payload.lastEid])
          .limit(payload.limit ?? PDefaultValues.limit);
    } else if (!(payload.isLoadNext ?? true) && isNotNull(payload.firstEid)) {
      query = query
          .endBefore([payload.firstEid])
          .limitToLast(payload.limit ?? PDefaultValues.limit);
    }
    if (isNull(payload.firstEid) && isNull(payload.lastEid)) {
      query = query.limit(payload.limit!);
    }

    await query.get().then((querySnapshot) {
      // Append the new documents to your existing list...
      if (querySnapshot.docs.isNotEmpty) {
        list = querySnapshot.docs
            .map((e) => MFriend.fromJson((e.data() as Map<String, dynamic>)))
            .toList();
      }
    });
    list.map((e) {
      printer(e.toJson());
      return e;
    }).toList();
    if (list.isEmpty) {
      return List.generate(
        10,
        (index) => MFriend(
          userId: index.toString(),
          pImage: PDefaultValues.profileImage,
          name: "Friend -$index",
          lastMessage: "hello!!, i am Friend -$index",
        ),
      );
    }
    return list;
  }

  // @override
  // Future<void> updateHomeNote(MFriend payload) async {
  //   return firebaseFirestore
  //       .collection(PKeys.secretNote)
  //       .doc(cProfile.uid)
  //       .collection(PKeys.secretNote)
  //       .doc(payload.userId)
  //       .update((payload.toJson()));
  // }
}
