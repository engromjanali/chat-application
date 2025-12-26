import 'package:chat_application/core/constants/default_values.dart';
import 'package:chat_application/core/extensions/ex_build_context.dart';
import 'package:chat_application/core/extensions/ex_padding.dart';
import 'package:chat_application/core/functions/f_snackbar.dart';
import 'package:chat_application/core/functions/f_url_launcher.dart';
import 'package:chat_application/core/services/navigation_service.dart';
import 'package:chat_application/core/widgets/w_dialog.dart';
import 'package:chat_application/features/profile/controllers/c_profile.dart';
import 'package:chat_application/features/profile/view/s_faq.dart';
import 'package:chat_application/gen/assets.gen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/state_manager.dart';

class MSItem {
  final String icon;
  final String label;
  final Function() onTap;
  final Widget? child;
  MSItem({
    this.child,
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

List<MSItem> profileItem = [
  MSItem(
    icon: Assets.icons.profile,
    label: "User ID",
    onTap: () {
      CProfile cProfile = Get.find<CProfile>();
      Clipboard.setData(
        ClipboardData(text: cProfile.mProfileData.id ?? PDefaultValues.noName),
      );
      showSnackBar("Copyed!");
    },
    child: _WCopyButton(),
  ),
];

List<MSItem> menuList = [
  MSItem(
    icon: Assets.icons.restorePurchase,
    label: "Restore Purchase",
    onTap: () {
      showSnackBar("Under build");
    },
  ),
  MSItem(
    icon: Assets.icons.faq,
    label: "FAQ",
    onTap: () {
      SFaq().push();
    },
  ),
  MSItem(
    icon: Assets.icons.feedback,
    label: "Feedback",
    onTap: () {
      OpenURLs.open(type: OpenType.url, value: PDefaultValues.linkedIn);
    },
  ),
  MSItem(
    icon: Assets.icons.rating,
    label: "Rate Us",
    onTap: () {
      OpenURLs.open(type: OpenType.url, value: PDefaultValues.linkedIn);
    },
  ),
  MSItem(
    icon: Assets.icons.tramsOfUse,
    label: "Terms of Use",
    onTap: () {
      OpenURLs.open(
        type: OpenType.url,
        value: PDefaultValues.termsConditionUrl,
      );
    },
  ),
  MSItem(
    icon: Assets.icons.privacyAndPolicy,
    label: "Privacy Policy",
    onTap: () {
      OpenURLs.open(type: OpenType.url, value: PDefaultValues.privacyUrlLink);
    },
  ),
  MSItem(
    icon: Assets.icons.power,
    label: "SignOut For All Devices",
    onTap: () async {
      WDialog.confirmExitLogout(
        context: NavigationService.currentContext,
        isLogOut: true,
        onYesPressed: () {
          Navigation.pop();
          CProfile cProfile = Get.find<CProfile>();
          cProfile.changeSessionKey();
        },
      );
    },
  ),
  MSItem(
    icon: Assets.icons.power,
    label: "SignOut",
    onTap: () async {
      WDialog.confirmExitLogout(
        context: NavigationService.currentContext,
        isLogOut: true,
        onYesPressed: () {
          CProfile cProfile = Get.find<CProfile>();
          cProfile.logOut();
        },
      );
    },
  ),
];

class _WCopyButton extends StatelessWidget {
  _WCopyButton({super.key});
  CProfile cProfile = Get.find<CProfile>();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GetBuilder<CProfile>(
          builder: (cProfile) {
            return Expanded(
              child: Text(
                cProfile.mProfileData.id ?? PDefaultValues.noName,
                style: context.textTheme?.bodySmall,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
              ).pR(),
            );
          },
        ),
        Icon(Icons.file_copy, color: context.primaryTextColor),
      ],
    );
  }
}
