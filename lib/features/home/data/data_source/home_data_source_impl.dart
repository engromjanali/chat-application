import 'package:chat_application/core/constants/default_values.dart';
import 'package:chat_application/core/constants/keys.dart';
import 'package:chat_application/core/extensions/ex_date_time.dart';
import 'package:chat_application/core/functions/f_is_null.dart';
import 'package:chat_application/core/functions/f_printer.dart';
import 'package:chat_application/core/services/dio_service.dart';
import 'package:chat_application/features/home/data/data_source/home_data_source.dart';
import 'package:chat_application/features/home/data/model/m_friend.dart';
import 'package:chat_application/features/home/domain/entryes/e_message.dart';
import 'package:chat_application/features/home/domain/entryes/e_query.dart';
import 'package:chat_application/features/home/presentation/controller/c_home.dart';
import 'package:chat_application/features/profile/controllers/c_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as fs;
import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

class HomeDatasourceImpl extends IHomeDataSource {
  CProfile cProfile = Get.find<CProfile>();

  // @override
  // Future<void> addHomeFriend(MFriend payload) async {
  //   await firebaseFirestore
  //       .collection(PKeys.secretFriend)
  //       .doc(cProfile.uid)
  //       .collection(PKeys.secretFriend)
  //       .doc(payload.userId)
  //       .set((payload.toJson()));
  // }

  @override
  Future<void> deteteHomeFriend(String id) async {
    await firebaseFirestore
        .collection(PKeys.friends)
        .doc(cProfile.uid)
        .collection(PKeys.friends)
        .doc(id)
        .delete();
  }

  @override
  Future<List<MFriend>> fetchHomeFriend(EQuery payload) async {
    List<MFriend> list = [];
    fs.Query query = fs.FirebaseFirestore.instance
        .collection(PKeys.friends)
        .doc(cProfile.uid)
        .collection(PKeys.friends)
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

  @override
  Future<void> sendMessage(EMessage payload) async {
    CHome cHome = Get.find<CHome>();
    final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("messages");
    List<String> networkFilePath = [];
    final newRef = _dbRef.push();

    // upload file first and store file path
    for (int i = 0; i < payload.files.length; i++) {
      String path = await uploadimage(
        payload.files[i],
        DateTime.timestamp().timestamp,
        payload.files[i].split("/").last,
      );
      networkFilePath.add(path);
    }

    newRef.set({
      "text": payload.text.trim(),
      "sender": payload.sender,
      "files": networkFilePath,
      "time": DateTime.now().toIso8601String(),
    });
  }

  // @override
  // Future<void> updateHomeFriend(MFriend payload) async {
  //   return firebaseFirestore
  //       .collection(PKeys.secretFriend)
  //       .doc(cProfile.uid)
  //       .collection(PKeys.secretFriend)
  //       .doc(payload.userId)
  //       .update((payload.toJson()));
  // }
}

Future<String> uploadimage(
  String imagePath,
  String fileName,
  String publicId,
) async {
  String path = "/v1_1/dskavcx9z/image/upload";
  if (isNull(imagePath)) {
    throw "Argument can't be null";
  }
  final FormData data = FormData.fromMap({
    if (isNotNull(imagePath))
      'file': await MultipartFile.fromFile(imagePath, filename: fileName),
    'upload_preset': "secure_note",
    "asset_folder": "chat_application",
    "public_id": publicId + fileName,
  });
  final res = await makeRequest(
    path: path,
    method: HTTPMethod.post,
    data: data,
  );
  return (res.data["secure_url"]);
}
