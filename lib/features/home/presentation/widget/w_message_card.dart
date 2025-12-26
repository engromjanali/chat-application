import 'package:chat_application/core/extensions/ex_build_context.dart';
import 'package:chat_application/core/extensions/ex_date_time.dart';
import 'package:chat_application/core/extensions/ex_padding.dart';
import 'package:chat_application/core/widgets/w_card.dart';
import 'package:chat_application/features/home/data/model/m_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WMessageCard extends StatelessWidget {
  final MMessage mMessage;
  final bool isYourMessage;
  const WMessageCard({
    super.key,
    required this.mMessage,
    this.isYourMessage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        isYourMessage ? gapX(20.w) : SizedBox.shrink(),

        Flexible(
          child: Align(
            alignment: isYourMessage
                ? AlignmentGeometry.centerRight
                : AlignmentGeometry.centerLeft,
            child: WCard(
              color: context.theme.brightness == Brightness.dark
                  ? context.cardColor
                  : isYourMessage
                  ? Colors.green.shade200
                  : Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(mMessage.text),
                  Text(
                    mMessage.time?.format(
                          DateTimeFormattingExtension.formatDDMMMYYYY_I_HHMMA,
                        ) ??
                        "No-Date",
                    style: context.textTheme?.bodyMedium,
                  ),
                ],
              ).pAll(value: 8),
            ),
          ),
        ),

        !isYourMessage ? gapX(20.w) : SizedBox.shrink(),
      ],
    );
  }
}
