import 'package:chat_application/core/constants/default_values.dart';
import 'package:chat_application/core/extensions/ex_build_context.dart';
import 'package:chat_application/core/extensions/ex_expanded.dart';
import 'package:chat_application/core/extensions/ex_padding.dart';
import 'package:chat_application/core/functions/f_is_null.dart';
import 'package:chat_application/core/functions/f_printer.dart';
import 'package:chat_application/core/services/image_picker_services.dart';
import 'package:chat_application/core/services/navigation_service.dart';
import 'package:chat_application/core/widgets/image/m_image_payload.dart';
import 'package:chat_application/core/widgets/image/w_image.dart';
import 'package:chat_application/core/widgets/w_dialog.dart';
import 'package:chat_application/core/widgets/w_image_source_dialog.dart';
import 'package:chat_application/core/widgets/w_text_field.dart';
import 'package:chat_application/features/home/data/model/m_message.dart';
import 'package:chat_application/features/home/domain/entryes/e_firend.dart';
import 'package:chat_application/features/home/domain/entryes/e_message.dart';
import 'package:chat_application/features/home/presentation/controller/c_home.dart';
import 'package:chat_application/features/home/presentation/widget/w_message_card.dart';
import 'package:chat_application/features/profile/controllers/c_profile.dart';
import 'package:chat_application/gen/assets.gen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:image_picker/image_picker.dart';

class SConvartation extends StatefulWidget {
  final EFriend eFriend;
  const SConvartation({super.key, required this.eFriend});

  @override
  State<SConvartation> createState() => _SConvartationState();
}

class _SConvartationState extends State<SConvartation> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("messages");
  final CProfile cProfile = Get.find<CProfile>();
  final TextEditingController _controller = TextEditingController();
  ValueNotifier<List<XFile>> fileNotifier = ValueNotifier<List<XFile>>([]);

  void sendMessage() async {
    if (_controller.text.trim().isEmpty && fileNotifier.value.isEmpty) return;

    CHome cHome = Get.find<CHome>();
    cHome.sendMessage(
      EMessage(
        messageId: "messageId",
        text: _controller.text.trim(),
        files: fileNotifier.value.map((val) => val.path).toList(),
        sender: cProfile.mProfileData.id ?? "No-Id",
        time: null,
      ),
    );

    _controller.clear();
    fileNotifier.value.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 20.w,
        title: Row(
          children: [
            WImage(
              widget.eFriend.pImage,
              payload: MImagePayload(isCircular: true, isProfileImage: true),
            ).pR(),
            Flexible(
              child: Text(
                widget.eFriend.name ?? PDefaultValues.noName,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () async {
              // clear all history
              bool? res = await WDialog.showCustom(
                context: context,
                children: [
                  Text("Clear History!"),
                  TextButton(
                    onPressed: () {
                      Navigation.pop(data: true);
                    },
                    child: Text("Yes"),
                  ),
                ],
              );

              if (res ?? false) {
                _dbRef.remove();
              }
            },
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
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
                  printer(messages[index].messageId);
                  return WMessageCard(
                    eMessage: messages[index],
                    isYourMessage:
                        cProfile.mProfileData.id == messages[index].sender,
                  ).pV();
                },
              );
            },
          ).expd(),
          gapY(10.h),

          /// INPUT
          Row(
            children: [
              GestureDetector(
                onTap: () async {
                  ImageSource? res = await WISSDialog(context);
                  if (isNotNull(res)) {
                    if (res == ImageSource.camera) {
                      ImagePickerServices().pickSingleImage(
                        choseFrom: ImageSource.camera,
                      );
                    } else {
                      // don't lose already selected file
                      fileNotifier.value;

                      List<XFile>? pickedFile = await ImagePickerServices()
                          .pickMultipleImage();
                      fileNotifier.value.addAll(pickedFile ?? []);
                      sendMessage();
                    }
                  }
                },
                child: SvgPicture.asset(
                  Assets.icons.add!,
                  height: 25.w,
                  width: 25.w,
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    context.primaryTextColor!,
                    BlendMode.srcIn,
                  ),
                ).pR(),
              ),

              WTextField(
                hintText: "Message",
                controller: _controller,
                maxLines: 5,
                minLines: 1,
                textInputAction: TextInputAction.newline,
                suffixIcon: GestureDetector(
                  onTap: sendMessage,
                  child: const Icon(Icons.send),
                ),
              ).expd(),
            ],
          ),
        ],
      ).pAll(),
    );
  }
}
