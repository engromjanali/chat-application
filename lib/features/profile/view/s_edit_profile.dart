
import 'package:chat_application/core/constants/dimension_theme.dart';
import 'package:chat_application/core/extensions/ex_keyboards.dart';
import 'package:chat_application/core/extensions/ex_padding.dart';
import 'package:chat_application/core/extensions/ex_strings.dart';
import 'package:chat_application/core/functions/f_is_null.dart';
import 'package:chat_application/core/functions/f_snackbar.dart';
import 'package:chat_application/core/services/image_picker_services.dart';
import 'package:chat_application/core/widgets/image/m_image_payload.dart';
import 'package:chat_application/core/widgets/image/w_image.dart';
import 'package:chat_application/core/widgets/w_bottom_nav_button.dart';
import 'package:chat_application/core/widgets/w_image_source_dialog.dart';
import 'package:chat_application/core/widgets/w_text_field.dart';
import 'package:chat_application/features/profile/controllers/c_profile.dart';
import 'package:chat_application/features/profile/data/models/m_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/state_manager.dart';
import 'package:image_picker/image_picker.dart';


class SEditProfile extends StatefulWidget {
  const SEditProfile({super.key});

  @override
  State<SEditProfile> createState() => _SEditProfileState();
}

class _SEditProfileState extends State<SEditProfile> {
  final CProfile cProfile = Get.find<CProfile>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController newPass = TextEditingController();
  TextEditingController confirmPass = TextEditingController();
  final ValueNotifier<XFile> selectedImage = ValueNotifier(XFile(""));
  MProfile payload = MProfile();

  void _onUpdate() async {
    context.unFocus();
    if ((_formKey.currentState?.validate() ?? false) &&
        newPass.text == confirmPass.text) {
      payload.updatedAt = DateTime.timestamp();
      await cProfile.editPrifle(payload);
      if (newPass.text.length >= 6) {
        cProfile.changePassword(newPass.text);
      }
    } else {
      showSnackBar(
        newPass.text != confirmPass.text
            ? "Confirm password dose not matched"
            : 'please fill all required field!',
        snackBarType: SnackBarType.warning,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    payload.id = cProfile.mProfileData?.id;
    payload.name = cProfile.mProfileData?.name;
    payload.email = cProfile.mProfileData?.email;
    payload.image = cProfile.mProfileData?.image;
  }

  @override
  void dispose() {
    newPass.dispose();
    confirmPass.dispose();
    selectedImage.dispose();
    payload = MProfile();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(title: Text("Edit prfile"), centerTitle: true),
      bottomNavigationBar: WBottomNavButton(
        label: 'Update',
        ontap: () {
          _onUpdate();
        },
      ).pAll(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: PTheme.paddingX,
          vertical: PTheme.paddingY,
        ),
        child: SafeArea(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ValueListenableBuilder(
                      valueListenable: selectedImage,
                      builder: (_, image, __) {
                        return InkWell(
                          onTap: () async {
                            ImageSource? res = await WISSDialog(context);
                            if (isNotNull(res)) {
                              selectedImage.value =
                                  await SvImagePicker().pickSingleImage(
                                    choseFrom: res!,
                                  ) ??
                                  selectedImage.value;
                              if (isNotNull(selectedImage.value.path)) {
                                payload.image = selectedImage.value.path;
                              }
                            }
                          },
                          child: GetBuilder<CProfile>(
                            builder: (controller) {
                              return WImage(
                                isNotNull(image.path)
                                    ? image.path
                                    : controller.mProfileData.image,
                                payload: MImagePayload(
                                  height: 100.h,
                                  width: 100.w,
                                  isCircular: true,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),

                WTextField.requiredField(
                  initialText: cProfile.mProfileData?.name,
                  label: "Full Name",
                  onChanged: (v) {
                    payload.name = v;
                  },
                ).pB(),

                WTextField.requiredField(
                  enable: false,
                  initialText: cProfile.mProfileData?.email,
                  label: "Email Address",
                  validator: (value) {
                    if (value == null) return "Enter Email!";
                    if (!value.isValidEmail) return "Invalid Email!";
                    return null;
                  },
                  onChanged: (v) {
                    payload.email = v;
                  },
                ).pB(),

                WTextField.obsecureText(
                  controller: newPass,
                  isRequired: false,
                  label: "New Password",
                  hintText: "Enter password (ignore, to keep unchanged)",
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return null;
                    if (value.contains(" ")) return "Spaces not allowed!";
                    if (value.trim().length < 6) {
                      return "Use minimum of six letters!";
                    }
                    return null;
                  },
                  onChanged: (v) {
                    // payload.password = v;
                  },
                ).pB(value: 16),
                WTextField.obsecureText(
                  controller: confirmPass,
                  isRequired: false,
                  label: "Confirm Password",
                  hintText: "Enter password (ignore, to keep unchanged)",
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return null;
                    if (value.contains(" ")) return "Spaces not allowed!";
                    if (value.trim().length < 6) {
                      return "Use minimum of six letters!";
                    }
                    return null;
                  },
                  onChanged: (v) {
                    // payload.password = v;
                  },
                ).pB(value: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
