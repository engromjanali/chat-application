import 'package:chat_application/core/controllers/c_check_point.dart';
import 'package:chat_application/core/extensions/ex_build_context.dart';
import 'package:chat_application/core/extensions/ex_padding.dart';
import 'package:chat_application/core/functions/f_call_back.dart';
import 'package:chat_application/core/services/local_auth_services.dart';
import 'package:chat_application/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class SpalshScreen extends StatefulWidget {
  const SpalshScreen({super.key});

  @override
  State<SpalshScreen> createState() => _SpalshScreenState();
}

class _SpalshScreenState extends State<SpalshScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callBackFunction(() {
      checkAuth();
    });
  }

  void checkAuth() async {
    if (true || await LocalAuthServices().showBiometric()) {
      final CCheckPoint checkPoint = CCheckPoint();
      checkPoint.initialization();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: checkAuth,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Center(
                child: SvgPicture.asset(
                  Assets.logo.logo,
                  height: 200.w,
                  width: 200.w,
                  colorFilter: ColorFilter.mode(
                    context.primaryTextColor!,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            Text(
              "Loading...",
              style: context.textTheme?.titleSmall?.copyWith(
                color: context.primaryTextColor,
              ),
            ).pB(value: 50),
          ],
        ),
      ),
    );
  }
}
