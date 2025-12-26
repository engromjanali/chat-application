import 'package:chat_application/core/constants/default_values.dart';
import 'package:chat_application/core/extensions/ex_expanded.dart';
import 'package:chat_application/core/extensions/ex_padding.dart';
import 'package:chat_application/core/widgets/w_card.dart';
import 'package:chat_application/core/widgets/w_text_field.dart';
import 'package:chat_application/features/home/data/model/m_friend.dart';
import 'package:chat_application/features/home/data/model/m_message.dart';
import 'package:chat_application/features/home/presentation/widget/w_message_card.dart';
import 'package:chat_application/features/profile/controllers/c_profile.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

class SConvartation extends StatefulWidget {
  final MFriend mFriend;
  const SConvartation({super.key, required this.mFriend});

  @override
  State<SConvartation> createState() => _SConvartationState();
}

class _SConvartationState extends State<SConvartation> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("messages");
  final CProfile cProfile = Get.find<CProfile>();
  final TextEditingController _controller = TextEditingController();

  void sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    final newRef = _dbRef.push();

    newRef.set({
      "text": _controller.text.trim(),
      "sender": cProfile.mProfileData.id,
      "time": DateTime.now().toIso8601String(),
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.mFriend.name ?? PDefaultValues.noName)),
      body: Column(
        children: [
          /// 🔥 MESSAGE LIST
          StreamBuilder<DatabaseEvent>(
            stream: _dbRef.onValue,
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
                return const Center(child: Text("No messages"));
              }

              final data = Map<dynamic, dynamic>.from(
                snapshot.data!.snapshot.value as Map,
              );

              final messages =
                  data.entries
                      .map((e) => MMessage.fromJson(e.key, e.value))
                      .toList()
                    ..sort(
                      (a, b) =>
                          a.time?.compareTo(b?.time ?? DateTime.timestamp()) ??
                          1,
                    );

              return ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return WMessageCard(
                    mMessage: messages[index],
                    isYourMessage:
                        cProfile.mProfileData.id == messages[index].sender,
                  ).pV();
                },
              );
            },
          ).expd(),

          gapY(10.h),

          /// ✉️ INPUT
          WTextField(
            hintText: "Message",
            controller: _controller,
            suffixIcon: GestureDetector(
              onTap: sendMessage,
              child: const Icon(Icons.send),
            ),
          ),
        ],
      ).pAll(),
    );
  }
}
