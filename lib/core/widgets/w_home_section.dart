import 'package:chat_application/core/constants/default_values.dart';
import 'package:chat_application/core/constants/dimension_theme.dart';
import 'package:chat_application/core/extensions/ex_build_context.dart';
import 'package:chat_application/core/extensions/ex_date_time.dart';
import 'package:chat_application/core/extensions/ex_expanded.dart';
import 'package:chat_application/core/extensions/ex_padding.dart';
import 'package:chat_application/core/functions/f_call_back.dart';
import 'package:chat_application/core/functions/f_is_null.dart';
import 'package:chat_application/core/functions/f_printer.dart';
import 'package:chat_application/core/services/navigation_service.dart';
import 'package:chat_application/core/widgets/w_app_shimmer.dart';
import 'package:chat_application/features/home/data/model/m_friend.dart';
import 'package:chat_application/features/home/data/model/m_query.dart';
import 'package:chat_application/features/home/presentation/controller/c_home.dart';
import 'package:chat_application/features/home/presentation/view/s_convartation.dart';
import 'package:chat_application/features/home/presentation/widget/w_friend_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class WHomeSection extends StatefulWidget {
  final Color? leadingColor;
  final String? title;
  // final List<MFriend>? items;
  final Function()? onTap;
  final bool asSliver;
  final Function()? loadNext;
  final Function()? loadPrevious;
  final Function((int, int))? removeCache;

  const WHomeSection({
    super.key,
    this.title,
    this.leadingColor,
    this.onTap,
    this.asSliver = false,
    this.loadNext,
    this.loadPrevious,
    this.removeCache,
  });

  @override
  State<WHomeSection> createState() => _WHomeSectionState();
}

class _WHomeSectionState extends State<WHomeSection> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ScrollOffsetController scrollOffsetController =
      ScrollOffsetController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final ScrollOffsetListener scrollOffsetListener =
      ScrollOffsetListener.create();
  double lastPosition = 0;
  ScrollDirection currentScrollDirection = ScrollDirection.reverse;
  CHome cHome = Get.find<CHome>();
  List<MFriend> friendItems = [];

  @override
  void initState() {
    super.initState();

    callBackFunction(() {
      printer("initate home");
      cHome.fetchSpacificItem(
        // payload: MSQuery(),
      );
      initScrolling();
    });
  }

  @override
  void dispose() {
    printer("dispose secret section");
    // Get.delete<CHome>();
    super.dispose();
  }

  void initScrolling() {
    printer("initScrolling");
    // 🔹 Listen to item positions (which items are visible)
    itemPositionsListener.itemPositions.addListener(() {
      final positions = itemPositionsListener.itemPositions.value;
      // Print all visible indexes
      // debugPrint("Visible indexes: ${positions.map((e) => e.index)}");

      if (positions.isNotEmpty) {
        final firstVisibleItem = positions.reduce(
          (a, b) => a.itemLeadingEdge < b.itemLeadingEdge ? a : b,
        );
        final lastVisibleItem = positions.reduce(
          (a, b) => a.itemTrailingEdge > b.itemTrailingEdge ? a : b,
        );
        final int lastVisibleIndex = lastVisibleItem.index;
        final int firstVisibleIndex = firstVisibleItem.index;
        // remove from end
        if (lastVisibleIndex >= 200 &&
            currentScrollDirection == ScrollDirection.reverse &&
            !(cHome!.isLoadingMore)) {
          // remove from top,
          removeData(lastVIndex: lastVisibleIndex);
        }
        // remove form end
        if (firstVisibleIndex <= 10 &&
            (friendItems.length) > 200 &&
            currentScrollDirection == ScrollDirection.forward &&
            !(cHome!.isLoadingMore)) {
          // remove from end,
          removeData(lastVIndex: lastVisibleIndex, removeFormTop: false);
        }
        // load previous
        if (firstVisibleIndex <= 10 &&
            currentScrollDirection == ScrollDirection.forward &&
            !(cHome!.isLoadingMore) &&
            (cHome!.hasMorePrev)) {
          // add previous
          printer("call for load previous");

          cHome!.fetchSpacificItem(payload: MQuery(isLoadNext: false));
        }
        // load next
        if (lastVisibleIndex >= ((friendItems.length) - 11) &&
            currentScrollDirection == ScrollDirection.reverse &&
            !(cHome!.isLoadingMore) &&
            (cHome!.hasMoreNext)) {
          // load next
          printer("call for load next");

          cHome!.fetchSpacificItem(payload: MQuery(isLoadNext: true));
        }
        // set scroll direction.
        double currentPosition = firstVisibleItem.itemLeadingEdge;
        if (currentPosition > lastPosition) {
          // printer("⬇️ Scrolling Forward");
          currentScrollDirection = ScrollDirection.forward;
        } else if (currentPosition < lastPosition) {
          // printer("⬆️ Scrolling Reverse");
          currentScrollDirection = ScrollDirection.reverse;
        }
        lastPosition = currentPosition;
      }
    });
  }

  Future<void> removeData({
    int? firstVIndex,
    int? lastVIndex,
    bool removeFormTop = true,
    int pageCount = 5,
  }) async {
    // using "jumpTo"
    if (!cHome!.isLoadingMore) {
      cHome!.isLoadingMore = true;

      if (removeFormTop) {
        printer("remove data from top");
        (friendItems).removeRange(0, (pageCount * PDefaultValues.limit));

        cHome!.update();
        itemScrollController.jumpTo(
          index: lastVIndex! - (pageCount * PDefaultValues.limit),
          alignment: 1,
        );
        // set first or last element id

        cHome!.firstSId = cHome!.secretList.first.userId;

        // set has more prev or not

        cHome!.hasMorePrev = true;
      } else {
        printer("remove data from bottom/end");
        friendItems.removeRange(
          (friendItems.length) - (pageCount * PDefaultValues.limit),
          (friendItems.length),
        );
        cHome!.update();
        // set first or last element id

        cHome!.lastSId = cHome!.secretList.last.userId;

        // set has more next or not
        cHome!.hasMoreNext = true;
      }
      // set flag

      cHome!.isLoadingMore = false;
      cHome!.update();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CHome>(
      builder: (_) {
        friendItems = cHome!.secretList;

        printer("rebuild ${friendItems.length}");
        return child();
      },
    );
  }

  Widget child() {
    return Column(
      children: [
        if ((cHome.isLoadingMore) && (cHome.hasMorePrev))
          ListView.builder(
            shrinkWrap: true,
            // controller: NeverScrollableScrollPhysics(),
            itemCount: 2,
            itemBuilder: (context, index) => WAppsShimmer().pB(value: 16),
          ),
        ScrollablePositionedList.builder(
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: (friendItems.length) + 1,
          itemBuilder: builder,
          itemScrollController: itemScrollController,
          scrollOffsetController: scrollOffsetController,
          itemPositionsListener: itemPositionsListener,
          scrollOffsetListener: scrollOffsetListener,
        ).expd(),
      ],
    ).pB().expd();
  }

  Widget builder(BuildContext context, int index) {
    Widget? prevChild;
    Widget? nextChild;
    // for previous loader
    if (index == 0 && (cHome.isLoadingMore) && !(cHome.isLoadNext)) {
      prevChild = ListView.builder(
        padding: EdgeInsets.all(0),
        shrinkWrap: true,
        itemCount: 2,
        itemBuilder: (context, index) => WAppsShimmer().pB(value: 16),
      );
    }
    // next loader
    if (index == (friendItems.length) &&
        (cHome.isLoadNext) &&
        (cHome.isLoadingMore)) {
      printer("loading next");
      nextChild = ListView.builder(
        padding: EdgeInsets.all(0),
        shrinkWrap: true,
        itemCount: 2,
        itemBuilder: (context, index) => WAppsShimmer().pB(value: 16),
      );
    }
    String? dateTime;
    if (index < (friendItems.length)) {
      dateTime =
          friendItems[index].time?.format(
            DateTimeFormattingExtension.formatDDMMMYYYY_I_HHMMA,
          ) ??
          PDefaultValues.noName;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // loading
        if (isNotNull(prevChild)) prevChild!,
        // exist items
        if (index < (friendItems.length))
          WFriendTile(
            onTap: () {
              SConvartation(mFriend: friendItems[index]).push();
            },
            mFriend: friendItems[index],
          ),
        // loading
        if (isNotNull(nextChild)) nextChild!,
      ],
    ).pV();
  }

  // void onAction(ActionType actionType, int index) {
  //   MFriend? mHome;
  //   if (widget.isHomeNote) {
  //     mHome = friendItems[index];
  //   }
  //   friendItems.removeAt(index);

  //   widget.isHomeNote ? cHome!.update() : cPasskey!.update();
  // if (actionType == ActionType.edit) {
  //   if (widget.isHomeNote) {
  //     // note
  //     SAdd(
  //       isEditPage: true,
  //       onlyNote: true,
  //       mHome: mHome,
  //       isHome: true,
  //     ).push();
  //   } else {
  //     //passkey
  //     SAPasskey(isEdit: true, mPasskey: mPasskey).push();
  //   }
  // } else if (actionType == ActionType.removeFromVault &&
  //   widget.isHomeNote) {
  // CTask cTask = Get.put(
  //   CTask(TaskRepositoryImpl(TaskDataSourceImpl())),
  // );
  // MTask payload = MTask(
  //   title: mHome?.title,
  //   points: mHome?.points,
  //   details: mHome?.details,
  //   endAt: null,
  //   createdAt: mHome?.createdAt,
  //   updatedAt: mHome?.updatedAt,
  //   finishedAt: null,
  // );
  //   cTask.addTask(payload);
  //   cHome!.deleteHome(mHome!.id!);
  //   Get.delete<CTask>();
  // } else if (actionType == ActionType.delete) {
  //   // delete
  //   WDialog.show(
  //     title: "Confirm Delete?",
  //     content: "if you delete you will not avail to restore it again!",
  //     context: context,
  //     onConfirm: () {
  //       if (widget.isHomeNote) {
  //         cHome!.deleteHome(mHome!.id!);
  //       } else {
  //         cPasskey!.deletePasskey(mPasskey!.id!);
  //       }
  //     },
  //   );
  // }
  // }
}
