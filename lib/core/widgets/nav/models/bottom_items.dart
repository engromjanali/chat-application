import 'package:chat_application/features/home/presentation/view/s_home.dart';
import 'package:chat_application/features/profile/view/s_profile.dart';
import 'package:chat_application/gen/assets.gen.dart';
import 'm_nav_bar_item.dart';

List<MNavBarItem> homeNevItem = [
  MNavBarItem(
    title: "Chat",
    unSelectedIcon: Assets.icons.taskChecklist,
    icon: Assets.icons.taskChecklist,
    child: SHome(),
  ),
  MNavBarItem(
    title: "Profile",
    unSelectedIcon: Assets.icons.profile,
    icon: Assets.icons.profile,
    child: SProfile(),
  ),
];
