import 'package:chat_application/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'm_nav_bar_item.dart';

List<MNavBarItem> homeNevItem = [
  MNavBarItem(
    title: "Task",
    unSelectedIcon: Assets.icons.taskChecklist,
    icon: Assets.icons.taskChecklist,
    child: Container(),
  ),
  MNavBarItem(
    title: "S Watch",
    unSelectedIcon: Assets.icons.stopwatch,
    icon: Assets.icons.stopwatch,
    child: Placeholder(),
  ),

  MNavBarItem(
    title: "Add",
    unSelectedIcon: Assets.icons.add,
    icon: Assets.icons.add,
    child: Placeholder(),
  ),
  MNavBarItem(
    title: "Note",
    unSelectedIcon: Assets.icons.notebook,
    icon: Assets.icons.notebook,
    child: Placeholder(),
  ),
  MNavBarItem(
    title: "Profile",
    unSelectedIcon: Assets.icons.profile,
    icon: Assets.icons.profile,
    child: Placeholder(),
  ),
];
