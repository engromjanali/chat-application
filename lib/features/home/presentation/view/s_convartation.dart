import 'package:chat_application/core/extensions/ex_padding.dart';
import 'package:chat_application/core/widgets/w_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SConvartation extends StatefulWidget {
  final String name;
  const SConvartation({super.key, required this.name});

  @override
  State<SConvartation> createState() => _SConvartationState();
}

class _SConvartationState extends State<SConvartation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.name)),
      body: SafeArea(
        child: ListView.builder(
          itemBuilder: (context, index) {
            return WMessageCard(isYourMessage: index % 2 == 0).pV();
          },
          itemCount: 20,
        ).pAll(),
      ),
    );
  }
}

class WMessageCard extends StatelessWidget {
  final bool isYourMessage;
  const WMessageCard({super.key, this.isYourMessage = true});

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
              color: isYourMessage ? Colors.green.shade200 : Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "data slkdfjs dflskdflskdfl;\n asdfs;dflksldkfjas f sdf s df sad gf\nas g as ghsa g\n sad gas g aw g3w4\n yhwotkjlerkm l;kwsz ",
                  ),
                  Text("12:12 pm"),
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
