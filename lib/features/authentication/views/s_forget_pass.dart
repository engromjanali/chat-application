import 'package:chat_application/core/widgets/load_and_error/models/view_state_model.dart';
import 'package:chat_application/core/widgets/w_button.dart';
import 'package:chat_application/core/widgets/w_dialog.dart';
import 'package:chat_application/features/authentication/controller/c_auth.dart';
import 'package:chat_application/features/authentication/data/data_source/auth_data_source_impl.dart';
import 'package:chat_application/features/authentication/data/model/m_token.dart';
import 'dart:math';
import 'package:chat_application/core/constants/default_values.dart';
import 'package:chat_application/core/constants/dimension_theme.dart';
import 'package:chat_application/core/constants/keys.dart';
import 'package:chat_application/core/extensions/ex_build_context.dart';
import 'package:chat_application/core/extensions/ex_expanded.dart';
import 'package:chat_application/core/extensions/ex_keyboards.dart';
import 'package:chat_application/core/extensions/ex_padding.dart';
import 'package:chat_application/core/extensions/ex_strings.dart';
import 'package:chat_application/core/functions/f_call_back.dart';
import 'package:chat_application/core/functions/f_is_null.dart';
import 'package:chat_application/core/functions/f_printer.dart';
import 'package:chat_application/core/functions/f_snackbar.dart';
import 'package:chat_application/core/services/dio_service.dart';
import 'package:chat_application/core/services/image_picker_services.dart';
import 'package:chat_application/core/services/navigation_service.dart';
import 'package:chat_application/core/widgets/image/m_image_payload.dart';
import 'package:chat_application/core/widgets/image/w_image.dart';
import 'package:chat_application/core/widgets/w_app_bar.dart';
import 'package:chat_application/core/widgets/w_bottom_nav_button.dart';
import 'package:chat_application/core/widgets/w_card.dart';
import 'package:chat_application/core/widgets/w_container.dart';
import 'package:chat_application/core/widgets/w_image_source_dialog.dart';
import 'package:chat_application/core/widgets/w_text_field.dart';
import 'package:chat_application/features/authentication/data/data_source/auth_data_source.dart';
import 'package:chat_application/features/authentication/data/model/m_auth.dart';
import 'package:chat_application/features/authentication/data/model/m_token.dart';
import 'package:chat_application/features/authentication/data/repository/auth_repository_impl.dart';
import 'package:chat_application/features/authentication/data/social_media/social_data_source.dart';
import 'package:chat_application/features/authentication/views/s_sign_in.dart';
import 'package:chat_application/features/profile/controllers/c_profile.dart';
import 'package:chat_application/features/profile/data/models/m_faq.dart';
import 'package:chat_application/features/profile/data/models/m_profile.dart';
import 'package:chat_application/features/profile/data/models/m_setting_item.dart';
import 'package:chat_application/features/profile/view/s_edit_profile.dart';
import 'package:chat_application/gen/assets.gen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/state_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';


class SForgetPass extends StatefulWidget {
  const SForgetPass({super.key});

  @override
  State<SForgetPass> createState() => _SSignInState();
}

class _SSignInState extends State<SForgetPass> {
  final CAuth _cAuth = Get.put(
    CAuth(AuthRepositoryImpl(AuthDataSourceImpl())),
  );

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final ValueNotifier<bool> isRemember = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isAgree = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isSignUp = ValueNotifier<bool>(false);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passController.dispose();
    isRemember.dispose();
    isSignUp.dispose();
    isAgree.dispose();
    Get.delete<CAuth>();
    super.dispose();
  }

  void _onSubmit() {
    context.unFocus();
    if (_formKey.currentState?.validate() ?? false) {
      CAuth cAuth = Get.put(
        CAuth(AuthRepositoryImpl(AuthDataSourceImpl())),
      );
      cAuth.sendForgetMail(emailController.text);
      emailController.text = "";
      Navigation.pop();
      WDialog.show(
        context: context,
        content:
            "Please check your gmail \"inbox\". \nif you can't see in inbox please check spam folder",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forget Password", style: context.textTheme?.titleSmall),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: PTheme.paddingX,
            vertical: PTheme.paddingY,
          ),
          child: Column(
            children: [
              _Header(isSignUp: true),
              gapY(32),
              ValueListenableBuilder<bool>(
                valueListenable: isSignUp,
                builder: (context, signUp, _) => _AuthForm(
                  formKey: _formKey,
                  emailController: emailController,
                ),
              ),
              gapY(24),
              ValueListenableBuilder<bool>(
                valueListenable: isAgree,
                builder: (context, agree, _) {
                  return ValueListenableBuilder<bool>(
                    valueListenable: isSignUp,
                    builder: (context, signUp, _) {
                      return GetBuilder<CAuth>(
                        builder: (controller) {
                          final isLoading =
                              controller.viewState == ViewState.loading;
                          return WPrimaryButton(
                            text: "Submit",
                            isLoading: isLoading,
                            isDisabled: signUp && !agree,
                            onTap: _onSubmit,
                          );
                        },
                      );
                    },
                  );
                },
              ).pB(value: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ----------------- HEADER -----------------
class _Header extends StatelessWidget {
  final bool isSignUp;
  const _Header({required this.isSignUp});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Note: \n1. after submit your confirm rest password request, you will get a email on your email addess if the email is exist on our system. \n\n2. if you can't see the mail in inbox, please check in \"SPAM\" folder.",
          style: context.textTheme?.bodySmall,
        ).pB(),
      ],
    );
  }
}

// ----------------- AUTH FORM -----------------
class _AuthForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  const _AuthForm({required this.formKey, required this.emailController});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          WTextField.requiredField(
            controller: emailController,
            label: "Email Address",
            validator: (value) {
              if (value == null) return "Enter Email!";
              if (!value.isValidEmail) return "Invalid Email!";
              return null;
            },
          ).pB(value: 12).withKey(ValueKey("email")),
        ],
      ),
    );
  }
}
