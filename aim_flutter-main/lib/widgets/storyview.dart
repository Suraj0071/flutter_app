import 'package:flutter_app/constants/constants.dart';
import 'package:flutter_app/screens/detail_screen.dart';
import 'package:story_view/story_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class StoryPageView extends StatelessWidget {
  final String id;
  final String bgImage;
  final String middleImage;
  final String bodyText;
  final String dateAdded;
  final EdgeInsetsGeometry padding;
  final String contactName;
  final String activityStatus;
  final ShapeBorder? shape;
  final String? source;
  final String? mobileNum;
  final String? emailAddress;
  StoryPageView({
    Key? key,
    this.id = "someDataId",
    this.padding = const EdgeInsets.all(6.0),
    this.bgImage = 'assets/images/profile/profile.png',
    this.middleImage = 'assets/images/lead_card_ic.svg',
    this.contactName = "Abaca Systems",
    this.dateAdded = "Date",
    this.activityStatus = "Sub contactName",
    this.bodyText = "Body Text",
    this.shape,
    this.source,
    this.mobileNum,
    this.emailAddress,
  }) : super(key: key);

  final controller = StoryController();

  String getHeading(String source) {
    if (source == "LEAD") return contactName;
    if (source == "DEAL") return activityStatus;
    return bodyText;
  }

  String getSubHeading(String source) {
    if (source == "LEAD") return activityStatus;
    if (source == "DEAL") return "in $bodyText";
    return "by $contactName";
  }

  String getDescription(String source) {
    if (source == "LEAD") return bodyText;
    if (source == "DEAL") return contactName;
    return activityStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        color: Colors.black.withOpacity(0.7), // Overlay color and opacity
        constraints: const BoxConstraints.expand(),
      ),
      Dialog(
          backgroundColor: Colors.black.withOpacity(1),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(SIZE_SM)),
          child: Container(
            height: source == "LEAD"
                ? MediaQuery.of(context).size.height * 0.66
                : MediaQuery.of(context).size.height * 0.58,
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
                borderRadius: const BorderRadius.all(Radius.circular(SIZE_SM))),
            child: SizedBox(
              child: Column(children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (source == 'LEAD') {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => DetailScreen(
                                id: id,
                                source: source.toString(),
                                name: getHeading(source.toString()))));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Details not available")));
                      }
                    },
                    child: Stack(
                      fit: StackFit.expand,
                      alignment: Alignment.center,
                      children: [
                        source == 'LEAD'
                            ? Image.asset(
                                bgImage,
                                fit: BoxFit.fitWidth,
                                width: double.maxFinite,
                              )
                            : Container(
                                width: double.maxFinite,
                              ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(boxShadow: [
                                BoxShadow(
                                  offset: const Offset(5, 9),
                                  spreadRadius: 2,
                                  blurRadius: 13,
                                  color: Colors.grey.withOpacity(.05),
                                )
                              ]),
                              child: SvgPicture.asset(middleImage),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Column(
                              children: [
                                Text(
                                  // source == 'LEAD' ? contactName : activityStatus,
                                  getHeading(source ?? ""),
                                  style: const TextStyle(fontSize: FONT_MD),
                                ),
                                Text(
                                  // source == 'LEAD' ? activityStatus : bodyText,
                                  getSubHeading(source ?? ""),
                                  style: const TextStyle(fontSize: FONT_SM),
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                source == 'LEAD'
                    ? Padding(
                        padding: const EdgeInsets.all(PADDING_MD),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  "assets/images/task.png",
                                  height: 26,
                                  width: 26,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(
                                  width: SIZE_SM,
                                ),
                                Expanded(
                                  child: Text(
                                    getDescription(source ?? ""),
                                    style: const TextStyle(fontSize: FONT_SM),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: PADDING_SM,
                            ),
                            const Divider(
                              color: Colors.grey,
                            ),
                            const SizedBox(
                              height: PADDING_SM,
                            ),
                            Text(
                              dateAdded,
                              style: const TextStyle(fontSize: FONT_SM),
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(PADDING_MD),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                    decoration: const BoxDecoration(
                                        color: ICON_BG_COLOR,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50))),
                                    width: 26,
                                    height: 26,
                                    padding: const EdgeInsets.all(6),
                                    child: SvgPicture.asset(
                                      "assets/images/bottom_nav_ic/profile.svg",
                                      fit: BoxFit.fitHeight,
                                      color: Colors.white,
                                    )),
                                const SizedBox(
                                  width: SIZE_SM,
                                ),
                                Expanded(
                                  child: Text(
                                    getDescription(source ?? ""),
                                    style: const TextStyle(fontSize: FONT_SM),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: PADDING_SM,
                            ),
                            source == 'DEAL'
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Mobile",
                                              style: TextStyle(
                                                  color: SECONDARY_CLR,
                                                  fontSize: FONT_XS),
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Text(
                                              mobileNum ?? NOT_PROVIDED,
                                              style: TextStyle(
                                                  fontSize: mobileNum == null
                                                      ? FONT_XSS
                                                      : FONT_SM,
                                                  color: mobileNum == null
                                                      ? SECONDARY_CLR
                                                      : NORMAL_TEXT_CLR),
                                            )
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Email",
                                            style: TextStyle(
                                                color: SECONDARY_CLR,
                                                fontSize: FONT_XS),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.42,
                                            child: Text(
                                              emailAddress ?? NOT_PROVIDED,
                                              style: TextStyle(
                                                  fontSize: emailAddress == null
                                                      ? FONT_XSS
                                                      : FONT_SM,
                                                  color: emailAddress == null
                                                      ? SECONDARY_CLR
                                                      : NORMAL_TEXT_CLR),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  )
                                : const SizedBox(),
                            const Divider(
                              color: Colors.grey,
                            ),
                            const SizedBox(
                              height: PADDING_SM,
                            ),
                            Text(
                              dateAdded,
                              style: const TextStyle(fontSize: FONT_SM),
                            ),
                          ],
                        ),
                      ),
                SizedBox(
                  height: 80,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(SIZE_MD),
                        topRight: Radius.circular(SIZE_MD),
                        bottomLeft: Radius.circular(SIZE_SM),
                        bottomRight: Radius.circular(SIZE_SM)),
                    child: Stack(
                      children: [
                        Image.asset(
                          "assets/images/bottom_nav_bg.png",
                          width: double.maxFinite,
                          fit: BoxFit.cover,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () async {
                                if (mobileNum != '') {
                                  Uri phoneno = Uri.parse('tel:$mobileNum');
                                  if (await launchUrl(phoneno)) {
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content:
                                                Text("Something went wrong!")));
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Phone number is not present!")));
                                }
                              },
                              icon: SvgPicture.asset(
                                "assets/images/call_outline_ic.svg",
                                width: SIZE_LG,
                                height: SIZE_LG,
                              ),
                            ),
                            const SizedBox(
                              width: SIZE_SM,
                            ),
                            const Padding(
                              padding:
                                  EdgeInsets.symmetric(vertical: PADDING_MD),
                              child: VerticalDivider(
                                color: BORDER_COLOR,
                              ),
                            ),
                            const SizedBox(
                              width: SIZE_SM,
                            ),
                            IconButton(
                                onPressed: () async {
                                  if (mobileNum != '') {
                                    Uri phoneno = Uri.parse('sms:$mobileNum');
                                    if (await launchUrl(phoneno)) {
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  "Something went wrong!")));
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "Phone number is not present!")));
                                  }
                                },
                                icon: SvgPicture.asset(
                                  "assets/images/messages.svg",
                                  width: SIZE_LG,
                                  height: SIZE_LG,
                                )),
                            const SizedBox(
                              width: SIZE_SM,
                            ),
                            const Padding(
                              padding:
                                  EdgeInsets.symmetric(vertical: PADDING_MD),
                              child: VerticalDivider(
                                color: BORDER_COLOR,
                              ),
                            ),
                            const SizedBox(
                              width: SIZE_SM,
                            ),
                            IconButton(
                                onPressed: () async {
                                  if (emailAddress != '') {
                                    Uri emailLaunch =
                                        Uri.parse('mailto:$emailAddress');
                                    if (await launchUrl(emailLaunch)) {
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  "Something went wrong!")));
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "Email address is not present!")));
                                  }
                                },
                                icon: SvgPicture.asset(
                                  "assets/images/mail_outline_ic.svg",
                                  width: SIZE_LG,
                                  height: SIZE_LG,
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ]),
            ),
          )),
      Positioned(
        top: SIZE_SM,
        right: SIZE_SM,
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.close,
            color: Colors.white,
          ),
        ),
      ),
    ]);
  }
}
