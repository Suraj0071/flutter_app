import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_app/constants/constants.dart';
import 'package:flutter_app/modal/detail_feed_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_dash/flutter_dash.dart';

class AllActivityTab extends StatelessWidget {
  final _scrollPhysics = const BouncingScrollPhysics();
  final bool hasData;
  final List<Activity>? data;
  final int total;

  const AllActivityTab(
      {super.key, this.hasData = false, this.data, this.total = 0});

  String getIcon(icon) {
    if (icon == 'PHONE') return "assets/images/call_blue_ic.svg";
    if (icon == 'NOTE') return "assets/images/notes_blue_ic.svg";
    if (icon == 'TASK') return "assets/images/notes_blue_ic.svg";
    return "assets/images/call_blue_ic.svg";
  }

  void _bottomSheetText(context, text) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(BORDER_RADIUS_LG),
              topLeft: Radius.circular(BORDER_RADIUS_LG) //),
              ),
        ),
        builder: (BuildContext context) {
          return Container(
            margin: const EdgeInsets.only(top: 60),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Summary",
                    style: Theme.of(context).textTheme.headlineLarge),
                Padding(
                  padding: EdgeInsets.all(PADDING_SM),
                  child: Text(text),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: PADDING_SM),
                  child: Divider(
                    thickness: 1,
                    color: DIVIDER_COLOR,
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 50,
                  margin: const EdgeInsets.symmetric(horizontal: SIZE_SM),
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: SECONDARY_BG_CLR,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(BORDER_RADIUS_MD),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: PADDING_SM, horizontal: PADDING_SM)),
                      child: const Text(
                        "Cancel",
                        style:
                            TextStyle(color: Colors.white, fontSize: FONT_SM),
                      )),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return hasData
        ? Stack(
            children: [
              SingleChildScrollView(
                physics: _scrollPhysics,
                child: Container(
                  margin: const EdgeInsets.only(
                      left: PADDING_XS, right: PADDING_XS, bottom: PADDING_XL),
                  padding: const EdgeInsets.all(PADDING_SM),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: BLUR_COLOR.withOpacity(0.5),
                        blurRadius: 25.0, // soften the shadow
                        spreadRadius: -5.0, //extend the shadow
                        offset: const Offset(
                          -3.0, // Move to right 10 horizontally
                          5.0, // Move to bottom 10 Vertically
                        ),
                      ),
                    ],
                    color: Colors.white,
                  ),
                  child: Column(children: [
                    Row(
                      children: [
                        const Text(
                          "ACTIVITIES | ",
                          style: TextStyle(
                              fontSize: FONT_XSS, color: NORMAL_TEXT_CLR),
                        ),
                        Text(total.toString(),
                            style: const TextStyle(
                                fontSize: FONT_XSS, color: NORMAL_TEXT_CLR)),
                      ],
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.only(top: PADDING_XS, bottom: PADDING_SM),
                      child: Divider(
                        thickness: 1.0,
                        color: DIVIDER_COLOR,
                      ),
                    ),
                    SizedBox(
                      // height: 400,
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                              horizontal: PADDING_SM),
                          itemCount: total,
                          itemBuilder: (BuildContext context, int index) {
                            final nDataList = data?[index];
                            return Stack(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.16,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                                getIcon(nDataList?.icon)),
                                            Dash(
                                                direction: Axis.vertical,
                                                length: index + 1 == total
                                                    ? 84
                                                    : 98,
                                                dashLength: 6,
                                                dashThickness: 1.2,
                                                dashColor: DASH_COLOR),
                                          ],
                                        )),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            nDataList?.source ?? "",
                                            style: const TextStyle(
                                                fontSize: FONT_SM,
                                                color: NORMAL_TEXT_CLR),
                                          ),
                                          const SizedBox(
                                            height: SIZE_XS,
                                          ),
                                          Text(nDataList?.createdDate ?? "",
                                              style: const TextStyle(
                                                  fontSize: FONT_XSS,
                                                  color: SEMI_SEC_TEXT_CLR)),
                                          const SizedBox(
                                            height: SIZE_SM,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              _bottomSheetText(
                                                  context,
                                                  nDataList!.desc
                                                          .toString()
                                                          .replaceAll(
                                                              "\\n", "\n") ??
                                                      "");
                                            },
                                            child: Text(
                                              nDataList!.desc
                                                      .toString()
                                                      .replaceAll(
                                                          "\\n", "\n") ??
                                                  "",
                                              style: const TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontSize: FONT_XS,
                                                  color: DARK_CLR),
                                              maxLines: 3,
                                              // maxLines: 3,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: SIZE_SM,
                                          ),
                                          const Divider(
                                            thickness: 1.0,
                                            color: DIVIDER_COLOR,
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                nDataList.sourceDB != 'NOTE'
                                    ? Positioned(
                                        top: 0,
                                        right: 0,
                                        child: GestureDetector(
                                          onTap: () {
                                            // markAsDoneActivity(nDataList);
                                          },
                                          child: SvgPicture.asset(nDataList!
                                                      .icon
                                                      .toString() ==
                                                  'COMPLETE'
                                              ? "assets/images/task_complete_ic.svg"
                                              : "assets/images/task_incomplete_ic.svg"),
                                        ))
                                    : SizedBox()
                              ],
                            );
                          }),
                    ),
                  ]),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: 80,
                  child: Stack(
                    children: [
                      Image.asset(
                        "assets/images/bottom_nav_bg.png",
                        width: double.maxFinite,
                        fit: BoxFit.cover,
                      ),
                      ClipRRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200.withOpacity(0.5)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: PADDING_XS, bottom: PADDING_MD),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () async {},
                                    icon: SvgPicture.asset(
                                      "assets/images/notes_outline_ic.svg",
                                      width: SIZE_LG,
                                      height: SIZE_LG,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: SIZE_XXS,
                                  ),
                                  const VerticalDivider(
                                    color: BORDER_COLOR,
                                  ),
                                  const SizedBox(
                                    width: SIZE_XXS,
                                  ),
                                  IconButton(
                                    onPressed: () async {},
                                    icon: SvgPicture.asset(
                                      "assets/images/call_outline_ic.svg",
                                      width: SIZE_LG,
                                      height: SIZE_LG,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: SIZE_XXS,
                                  ),
                                  const VerticalDivider(
                                    color: BORDER_COLOR,
                                  ),
                                  const SizedBox(
                                    width: SIZE_XXS,
                                  ),
                                  IconButton(
                                      onPressed: () async {},
                                      icon: SvgPicture.asset(
                                        "assets/images/mail_outline_ic.svg",
                                        width: SIZE_LG,
                                        height: SIZE_LG,
                                      )),
                                  const SizedBox(
                                    width: SIZE_XXS,
                                  ),
                                  const VerticalDivider(
                                    color: BORDER_COLOR,
                                  ),
                                  const SizedBox(
                                    width: SIZE_XXS,
                                  ),
                                  IconButton(
                                      onPressed: () async {},
                                      icon: SvgPicture.asset(
                                        "assets/images/user_location.svg",
                                        width: SIZE_LG,
                                        height: SIZE_LG,
                                      )),
                                  const SizedBox(
                                    width: SIZE_XXS,
                                  ),
                                  const VerticalDivider(
                                    color: BORDER_COLOR,
                                  ),
                                  const SizedBox(
                                    width: SIZE_XXS,
                                  ),
                                  IconButton(
                                      onPressed: () async {},
                                      icon: SvgPicture.asset(
                                        "assets/images/task_ic.svg",
                                        width: SIZE_LG,
                                        height: SIZE_LG,
                                      ))
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        : Container(
            margin: const EdgeInsets.only(
                left: PADDING_MD, right: PADDING_MD, bottom: PADDING_XL),
            padding: const EdgeInsets.all(PADDING_SM),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: BLUR_COLOR.withOpacity(0.5),
                  blurRadius: 25.0, // soften the shadow
                  spreadRadius: -5.0, //extend the shadow
                  offset: const Offset(
                    -3.0, // Move to right 10 horizontally
                    5.0, // Move to bottom 10 Vertically
                  ),
                ),
              ],
              color: Colors.white,
            ),
            child: const Center(child: Text("No activity to show!")),
          );
  }
}
