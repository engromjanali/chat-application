import 'package:chat_application/core/constants/default_values.dart';
import 'package:chat_application/core/extensions/ex_build_context.dart';
import 'package:chat_application/core/extensions/ex_date_time.dart';
import 'package:chat_application/core/extensions/ex_expanded.dart';
import 'package:chat_application/core/extensions/ex_padding.dart';
import 'package:chat_application/core/widgets/image/m_image_payload.dart';
import 'package:chat_application/core/widgets/image/w_image.dart';
import 'package:chat_application/core/widgets/w_card.dart';
import 'package:chat_application/features/home/data/model/m_friend.dart';
import 'package:flutter/material.dart';

class WFriendTile extends StatelessWidget {
  final Function()? onTap;
  final MFriend mFriend;
  const WFriendTile({super.key, this.onTap, required this.mFriend});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: WCard(
        child: Row(
          children: [
            // Profile Image
            WImage(
              mFriend.pImage,
              payload: MImagePayload(
                height: 50,
                width: 50,
                fit: BoxFit.fill,
                isProfileImage: true,
                isCircular: true,
              ),
            ).pR(),

            // name, last mesage and meta data.
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      mFriend.name ?? PDefaultValues.noName,
                      style: context.textTheme?.titleSmall,
                    ).expd(),
                    Text(
                      mFriend.time?.format(
                            DateTimeFormattingExtension
                                .formatDDMMMYYYY_I_HHMMSSA,
                          ) ??
                          PDefaultValues.noName,
                      style: context.textTheme?.bodySmall,
                    ),
                  ],
                ),
                Text(
                  mFriend.lastMessage ??
                      "Hello, Romjan How Are You?? I Wanna Meet to You.",
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme?.bodySmall,
                ),
              ],
            ).expd(),
          ],
        ).pAll(value: 4),
      ),
    );
  }
}
