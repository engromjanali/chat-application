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
      body: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: 20,
            itemBuilder: (context, index) {
              return WFriendTile();
            },
          ),
        ],
      ),
    );
  }
}

class WFriendTile extends StatelessWidget {
  const WFriendTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Profile Image
        CircleAvatar(radius: 100),

        // name, last mesage and meta data.
        // Column(
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        //     Row(
        //       children: [
        //         Flexible(child: Text("Romjan ali")),
        //         Text("12:23 pm"),
        //       ],
        //     ),
        //     Text("Hello, Romjan How Are You?? I Wanna Meet to You."),
        //   ],
        // ).expd(),
      ],
    );
  }
}
