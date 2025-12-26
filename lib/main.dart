import 'package:chat_application/core/controllers/c_theme.dart';
import 'package:chat_application/core/extensions/ex_build_context.dart';
import 'package:chat_application/core/functions/f_default_scrolling.dart';
import 'package:chat_application/core/services/navigation_service.dart';
import 'package:chat_application/firebase_options.dart';
import 'package:chat_application/features/home/presentation/view/s_home.dart';
import 'package:chat_application/spalsh.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

void main() async {
  await _init();
  runApp(
    // DevicePreview(enabled: !kReleaseMode, builder: (context) => _SCheckPoint()),
    DevicePreview(enabled: false, builder: (context) => _SCheckPoint()),
  );
  // runApp(const _SCheckPoint());
}

Future<void> _init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await FirebaseAppCheck.instance.activate(
  //   androidProvider: kReleaseMode
  //       ? AndroidProvider.playIntegrity
  //       : AndroidProvider.debug,
  //   // set to true to use the default providers configured in console
  //   // webProvider: ReCaptchaV3Provider('your-site-key'), // only for web if applicable
  // );
  //   await CNotification().requestPermission();
  //   FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  //   await CNotification().initNotification();
  // init base method otherwise we may get an error like "xyz was not initialized".
  // await SharedPrefService.instance.init();
  // await EncryptionService().init();
  // await DBHelper.getInstance.init();
}

class _SCheckPoint extends StatefulWidget {
  const _SCheckPoint();

  @override
  State<_SCheckPoint> createState() => __SCheckPointState();
}

class __SCheckPointState extends State<_SCheckPoint> {
  final CTheme themeController = Get.put(CTheme());
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CTheme>(
      // init: ,
      builder: (CTheme controller) {
        return ScreenUtilInit(
          designSize: kIsWeb ? Size(430, 932) : Size(430, 932),
          minTextAdapt: true,
          splitScreenMode: true,
          fontSizeResolver: (fontSize, screenUtil) {
            if (kIsWeb) {
              // On web: ignore scaling, just use original fontSize
              return fontSize.toDouble();
            } else {
              // On mobile: use normal scaled fontSize
              return fontSize * // orginial font size.
                  screenUtil.scaleWidth * // screen wise scale factor
                  screenUtil.textScaleFactor; // user devices text scale factor
            }
          },
          builder: (ctx, _) {
            return MaterialApp(
              locale: DevicePreview.locale(ctx),
              navigatorObservers: [NavigationService.routeObserver],
              debugShowCheckedModeBanner: false,
              navigatorKey: NavigationService.key,
              theme: controller.themeList.first,
              darkTheme: controller.themeList.last,
              themeMode: ThemeMode.system,
              builder: (contxtz, child) {
                child = DevicePreview.appBuilder(contxtz, child);

                return AnnotatedRegion<SystemUiOverlayStyle>(
                  value: SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                    statusBarIconBrightness:
                        contxtz.theme.brightness == Brightness.dark
                        ? Brightness.light
                        : Brightness.dark,
                  ),
                  child: ScrollConfiguration(
                    behavior: PScrollBehavior(),
                    child: kIsWeb
                        ? Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxWidth: 480,
                              ), // ✅ adjust width here
                              child: child!,
                            ),
                          )
                        : child!,
                  ),
                );
              },
              home: SpalshScreen(),
            );
          },
        );
      },
    );
  }
}
