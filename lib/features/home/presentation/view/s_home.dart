import 'package:chat_application/core/constants/colors.dart';
import 'package:chat_application/core/extensions/ex_build_context.dart';
import 'package:chat_application/core/extensions/ex_expanded.dart';
import 'package:chat_application/core/extensions/ex_padding.dart';
import 'package:chat_application/core/functions/f_printer.dart';
import 'package:chat_application/features/home/presentation/widget/w_home_section.dart';
import 'package:chat_application/features/home/data/data_source/home_data_source_impl.dart';
import 'package:chat_application/features/home/data/repositories/home_repositorie_impl.dart';
import 'package:chat_application/features/home/presentation/controller/c_home.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/state_manager.dart';

class SHome extends StatefulWidget {
  const SHome({super.key});

  @override
  State<SHome> createState() => _SHomeState();
}

class _SHomeState extends State<SHome> {
  CHome cHome = Get.put(CHome(HomeRepositoryImpl(HomeDatasourceImpl())));
  
  @override
  void dispose() {
    // TODO: implement dispose
    Get.delete<CHome>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Whatsapp")),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search_sharp),
              hintText: "Search Task Here",
              suffixIcon: IconButton(
                onPressed: () {},
                icon: Icon(Icons.tune_rounded),
              ),
            ),
          ).pB(),

          GetBuilder<CHome>(
            builder: (controller) {
              return RefreshIndicator(
                onRefresh: () async {
                  printer("cHome find");
                  CHome cHome = Get.find<CHome>();
                  cHome.clear();
                  cHome.fetchHome();
                },
                color: context.primaryTextColor,
                backgroundColor: context.fillColor,
                child: Column(
                  children: [
                    WHomeSection(
                      leadingColor: PColors.completedColor,
                      asSliver: true,
                    ),
                  ],
                ),
              );
            },
          ).expd(),

          // ListView.builder(
          //   padding: EdgeInsets.all(0),
          //   physics: NeverScrollableScrollPhysics(),
          //   shrinkWrap: true,
          //   itemCount: 30,
          //   itemBuilder: (context, index) {
          //     return WFriendTile(
          //       onTap: () {
          //         printer("index: $index");
          //         SConvartation(name: "person-$index").push();
          //       },
          //     ).pV();
          //   },
          // ),

          // input section 
          
        ],
      ).pAll(),
    );
  }
}
