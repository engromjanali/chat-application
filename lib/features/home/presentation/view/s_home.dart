import 'package:chat_application/core/extensions/ex_expanded.dart';
import 'package:chat_application/core/extensions/ex_padding.dart';
import 'package:chat_application/core/functions/f_printer.dart';
import 'package:chat_application/core/services/navigation_service.dart';
import 'package:chat_application/core/widgets/image/m_image_payload.dart';
import 'package:chat_application/core/widgets/image/w_image.dart';
import 'package:chat_application/core/widgets/w_card.dart';
import 'package:chat_application/features/home/presentation/view/s_convartation.dart';
import 'package:chat_application/features/home/presentation/widget/w_friend_tile.dart';
import 'package:flutter/material.dart';

class SHome extends StatefulWidget {
  const SHome({super.key});

  @override
  State<SHome> createState() => _SHomeState();
}

class _SHomeState extends State<SHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 30,
              itemBuilder: (context, index) {
                return WFriendTile(
                  onTap: () {
                    printer("index: $index");
                    SConvartation(name: "person-$index").push();
                  },
                ).pV();
              },
            ),
          ],
        ),
      ).pAll(),
    );
  }
}
