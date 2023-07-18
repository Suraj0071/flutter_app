import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_app/constants/constants.dart';
import 'package:flutter_app/modal/detail_feed_model.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BuyersJourneyTab extends StatefulWidget {
  final bool hasData;
  final List<BuyersJourney>? data;
  final int total;
  final String leadSource;

  BuyersJourneyTab(
      {super.key,
      this.hasData = false,
      this.data,
      this.total = 0,
      this.leadSource = ""});

  @override
  State<BuyersJourneyTab> createState() => _BuyersJourneyTabState();
}

class _BuyersJourneyTabState extends State<BuyersJourneyTab> {
  final _scrollPhysics = const BouncingScrollPhysics();

  String getBgImage(String type) {
    if (type == 'NOTE_ADDED') {
      return "assets/images/buyers_jour_notes_bg.png";
    }
    return "assets/images/buyers_journey_card_bg.png";
  }

  String getSelectedIcon(isSelected) {
    if (isSelected == 1) return "assets/images/selected_buyJour_ic.png";
    return "assets/images/not_selected_buyeJour_ic.png";
  }

  String getIcon(eventType) {
    if (eventType == "CONTACT_CREATED" || eventType == "CONTACT_UPDATED") {
      return "assets/images/buyers_user_ic.svg";
    } else if (eventType == "NOTE_ADDED" ||
        eventType == "NOTE_ADDED_FOR_OPPORTUNITY") {
      return "assets/images/buyers_notes_ic.svg";
    } else {
      return "assets/images/buyers_user_ic.svg";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                    "EVENTS | ",
                    style: TextStyle(fontSize: FONT_XSS, color: DARK_TEXT_CLR),
                  ),
                  Text(widget.total.toString(),
                      style: const TextStyle(
                          fontSize: FONT_SM, color: DARK_TEXT_CLR)),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: PADDING_XS, bottom: PADDING_SM),
                child: Divider(
                  thickness: 1.0,
                  color: DIVIDER_COLOR,
                ),
              ),
              ListView.builder(
                  // scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: PADDING_SM),
                  itemCount: widget.total,
                  itemBuilder: (BuildContext context, int index) {
                    final nDataList = widget.data?[index];
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                index == 0
                                    ? const SizedBox(
                                        height: 30,
                                      )
                                    : const Dash(
                                        direction: Axis.vertical,
                                        length: 30,
                                        dashLength: 6,
                                        dashThickness: 1.2,
                                        dashColor: DASH_COLOR),
                                Image.asset(
                                  index == 0
                                      ? getSelectedIcon(1)
                                      : getSelectedIcon(0),
                                  fit: BoxFit.cover,
                                ),
                                const Dash(
                                    direction: Axis.vertical,
                                    length: 250,
                                    dashLength: 6,
                                    dashThickness: 1.2,
                                    dashColor: DASH_COLOR),
                              ],
                            )),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: BLUR_COLOR.withOpacity(0.2),
                                  blurRadius: 25.0, // soften the shadow
                                  spreadRadius: -5.0, //extend the shadow
                                  offset: const Offset(
                                    -3.0, // Move to right 10 horizontally
                                    5.0, // Move to bottom 10 Vertically
                                  ),
                                ),
                              ],
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(SIZE_SM)),
                              color: Colors.white,
                            ),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(
                                    getBgImage(nDataList?.eventType ?? ""),
                                    fit: BoxFit.cover,
                                    height: 280,
                                    width: double.infinity,
                                  ),
                                ),
                                Positioned.fill(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: PADDING_SM,
                                            left: PADDING_XS,
                                            right: PADDING_XS),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                padding:
                                                    const EdgeInsets.all(2),
                                                decoration: const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(40),
                                                    ),
                                                    color: ICON_BG_COLOR),
                                                child: SvgPicture.asset(getIcon(
                                                    nDataList?.eventCode))),
                                            const SizedBox(
                                              width: SIZE_SM,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    nDataList?.eventType ?? "",
                                                    style: const TextStyle(
                                                        color: NORMAL_TEXT_CLR,
                                                        fontSize: FONT_SM),
                                                  ),
                                                  Text(
                                                    nDataList?.eventTime ?? "",
                                                    style: const TextStyle(
                                                        color: NORMAL_TEXT_CLR,
                                                        fontSize: FONT_XSS),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 2, horizontal: SIZE_SM),
                                        child: Divider(
                                          thickness: 1.0,
                                          color: DIVIDER_COLOR,
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            widget.leadSource == "ZAPIER"
                                                ? Image.asset(
                                                    "assets/images/zapier_logo.png",
                                                    fit: BoxFit.cover,
                                                    width: 100,
                                                  )
                                                : const SizedBox(),
                                            const SizedBox(
                                              height: 6,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: PADDING_SM),
                                              child: Text(
                                                nDataList!.description
                                                    .toString()
                                                    .replaceAll("\\n", "\n")
                                                    .replaceAll("nbsp;", " ")
                                                    .replaceAll("nbsp", " ")
                                                    .replaceFirst("null",
                                                        "Details not available"),
                                                style: const TextStyle(
                                                  color: DARK_TEXT_CLR,
                                                  fontSize: FONT_XSS,
                                                ),
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 5,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    );
                  }),
            ]),
          ),
        ),
      ],
    );
  }
}
