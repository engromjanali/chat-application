
import 'package:chat_application/core/extensions/ex_expanded.dart';
import 'package:chat_application/core/extensions/ex_padding.dart';
import 'package:chat_application/core/widgets/image/m_image_payload.dart';
import 'package:chat_application/core/widgets/image/w_image.dart';
import 'package:chat_application/core/widgets/w_card.dart';
import 'package:flutter/material.dart';

class WFriendTile extends StatelessWidget {
  final Function()? onTap;
  const WFriendTile({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: WCard(
        child: Row(
          children: [
            // Profile Image
            WImage("", payload: MImagePayload(height: 50)).pR(),

            // name, last mesage and meta data.
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(children: [Text("Romjan ali").expd(), Text("12:23 pm")]),
                Text(
                  "Hello, Romjan How Are You?? I Wanna Meet to You.",
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ).expd(),
          ],
        ).pAll(value: 4),
      ),
    );
  }
}
