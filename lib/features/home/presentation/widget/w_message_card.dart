import 'dart:math';
import 'package:chat_application/core/constants/dimension_theme.dart';
import 'package:chat_application/core/extensions/ex_build_context.dart';
import 'package:chat_application/core/extensions/ex_date_time.dart';
import 'package:chat_application/core/extensions/ex_padding.dart';
import 'package:chat_application/core/widgets/image/m_image_payload.dart';
import 'package:chat_application/core/widgets/image/w_image.dart';
import 'package:chat_application/core/widgets/w_card.dart';
import 'package:chat_application/features/home/domain/entryes/e_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WMessageCard extends StatelessWidget {
  final EMessage eMessage;
  final bool isYourMessage;
  const WMessageCard({
    super.key,
    required this.eMessage,
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
                  Text(eMessage.text),
                  WFile(
                    fileList: eMessage.files,
                    // fileList: List.generate(
                    //   Random.secure().nextInt(9),
                    //   (index) =>
                    //       "https://scontent.fdac5-2.fna.fbcdn.net/v/t39.30808-6/481009601_1304901404093445_5215300352095363775_n.jpg?_nc_cat=104&ccb=1-7&_nc_sid=cc71e4&_nc_eui2=AeHsImsQ8HUSDto5x3ojBjDTP9btEJxUeYQ_1u0QnFR5hLk1GLPpTxK25luAStajQVOYQTZ8Grq11dQzLXUoyr6h&_nc_ohc=uJk_SLACHCAQ7kNvwFndwYX&_nc_oc=AdnlXEJrByoNltr9Q7REuOEYqnIUbCqGWrWV0eQRrd4RyrXOh1zqsDcCqQ1PTVM0L08&_nc_zt=23&_nc_ht=scontent.fdac5-2.fna&_nc_gid=KJCjhPMPCLOEB9GdufCVNQ&oh=00_Afkbb2fAs8gm_j1G2IzowY8we9cU4seu2wac8EgS5_01XA&oe=69556A70",
                    // ),
                  ),
                  Text(
                    eMessage.time?.format(
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

class WFile extends StatelessWidget {
  List<String> fileList;
  WFile({super.key, required this.fileList});

  @override
  Widget build(BuildContext context) {
    int hasMore = fileList.length - 4;
    if (fileList.length == 1) {
      return SizedBox(
        child: WImage(
          fileList[0],
          payload: MImagePayload(
            fit: BoxFit.fill,
            height: 150.r,
            width: 150.r,
            borderRadius: PTheme.borderRadius,
          ),
        ),
      );
    }
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: fileList.length.clamp(0, 4),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemBuilder: (context, index) {
        return Stack(
          children: [
            SizedBox.expand(
              child: WImage(
                fileList[index],
                payload: MImagePayload(
                  fit: BoxFit.fill,
                  borderRadius: PTheme.borderRadius,
                ),
              ),
            ),
            // show it's how many rest image has.
            if (index == 3 && hasMore > 0)
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(PTheme.borderRadius),
                    ),
                  ),
                  Center(
                    child: Text(
                      "+ $hasMore",
                      style: context.textTheme?.titleLarge?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ).pAll(value: 2);
      },
    );
  }
}
