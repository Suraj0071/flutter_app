import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_app/constants/constants.dart';
import 'package:flutter_app/screens/call_log.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';

class InformationTab extends StatelessWidget {
  String fullName, firstName, lastName, source, city;
  String mobileNumber;
  String emailAddress;
  String leadOwner;
  String compName;
  String compWebsite;
  String compPhone;
  String compAnnualTurnover;
  String? currency;
  String gstNumber;

  InformationTab({
    super.key,
    this.fullName = "",
    this.city = "",
    this.source = "",
    this.firstName = "",
    this.lastName = "",
    this.mobileNumber = "",
    this.emailAddress = "",
    this.leadOwner = "",
    this.compName = "",
    this.compWebsite = "",
    this.compPhone = "",
    this.compAnnualTurnover = "",
    this.currency = "INR-₹",
    this.gstNumber = "",
  });

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          margin: EdgeInsets.only(
              left: PADDING_XS,
              right: PADDING_XS,
              bottom: source.toUpperCase() == 'WEBFORM'
                  ? PADDING_XL * 2.6
                  : PADDING_XL * 1.8),
          padding: const EdgeInsets.all(PADDING_SM),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: BLUR_COLOR.withOpacity(0.5),
                blurRadius: 25.0,
                spreadRadius: -5.0,
                offset: const Offset(
                  -3.0,
                  5.0,
                ),
              ),
            ],
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Text(
                    'DEFAULT',
                    style: TextStyle(fontSize: FONT_XSS, color: DARK_TEXT_CLR),
                  )
                ],
              ),
              const SizedBox(height: 2),
              const Divider(
                thickness: 1.0,
                color: DIVIDER_COLOR,
              ),
              const SizedBox(height: SIZE_SM),
              const Text(
                'Mobile',
                style: TextStyle(fontSize: FONT_XSS, color: SECONDARY_CLR),
              ),

              const SizedBox(height: SIZE_XS),
              Text(mobileNumber,
                  style: TextStyle(
                      fontSize:
                          mobileNumber == NOT_PROVIDED ? FONT_XSS : FONT_SM,
                      color: mobileNumber == NOT_PROVIDED
                          ? SECONDARY_CLR
                          : NORMAL_TEXT_CLR)),

              const SizedBox(height: SIZE_MD),
              const Text(
                'Email',
                style: TextStyle(fontSize: FONT_XSS, color: SECONDARY_CLR),
              ),
              const SizedBox(height: SIZE_XS),
              Text(emailAddress,
                  style: TextStyle(
                      fontSize:
                          emailAddress == NOT_PROVIDED ? FONT_XSS : FONT_SM,
                      color: emailAddress == NOT_PROVIDED
                          ? SECONDARY_CLR
                          : NORMAL_TEXT_CLR)),

              const SizedBox(height: SIZE_MD),
              const Text(
                'Owner',
                style: TextStyle(fontSize: FONT_XSS, color: SECONDARY_CLR),
              ),
              const SizedBox(height: SIZE_XS),
              Text(leadOwner,
                  style: TextStyle(
                      fontSize: leadOwner == NOT_PROVIDED ? FONT_XSS : FONT_SM,
                      color: leadOwner == NOT_PROVIDED
                          ? SECONDARY_CLR
                          : NORMAL_TEXT_CLR)),

              const SizedBox(height: SIZE_MD),
              const Text('COMPANY',
                  style: TextStyle(fontSize: FONT_XSS, color: DARK_TEXT_CLR)),

              const SizedBox(height: 2),
              const Divider(
                thickness: 1.0,
                color: DIVIDER_COLOR,
              ),
              const SizedBox(height: SIZE_XS),
              const Text(
                'Name',
                style: TextStyle(fontSize: FONT_XSS, color: SECONDARY_CLR),
              ),
              const SizedBox(height: SIZE_XS),
              Text(compName,
                  style: TextStyle(
                      fontSize: compName == NOT_PROVIDED ? FONT_XSS : FONT_SM,
                      color: compName == NOT_PROVIDED
                          ? SECONDARY_CLR
                          : NORMAL_TEXT_CLR)),

              const SizedBox(height: SIZE_MD),
              const Text(
                'Websites',
                style: TextStyle(fontSize: FONT_XSS, color: SECONDARY_CLR),
              ),

              const SizedBox(height: SIZE_XS),
              Text(compWebsite,
                  style: TextStyle(
                      fontSize:
                          compWebsite == NOT_PROVIDED ? FONT_XSS : FONT_SM,
                      color: compWebsite == NOT_PROVIDED
                          ? SECONDARY_CLR
                          : NORMAL_TEXT_CLR)),

              // Divider(),
              const SizedBox(height: SIZE_MD),
              const Text(
                'Phone',
                style: TextStyle(fontSize: FONT_XSS, color: SECONDARY_CLR),
              ),

              const SizedBox(height: SIZE_XS),
              Text(compPhone,
                  style: TextStyle(
                      fontSize: compPhone == NOT_PROVIDED ? FONT_XSS : FONT_SM,
                      color: compPhone == NOT_PROVIDED
                          ? SECONDARY_CLR
                          : NORMAL_TEXT_CLR)),

              // const SizedBox(height: SIZE_MD),
              // const Text(
              //   'Annual Turnover',
              //   style: TextStyle(fontSize: FONT_XSS, color: SECONDARY_CLR),
              // ),

              // const SizedBox(height: SIZE_XS),
              // Text(compAnnualTurnover,
              //     style: const TextStyle(
              //         fontSize: FONT_SM, color: NORMAL_TEXT_CLR)),

              // const SizedBox(height: SIZE_MD),
              // const Text(
              //   'Currency',
              //   style: TextStyle(fontSize: FONT_XSS, color: SECONDARY_CLR),
              // ),

              // const SizedBox(height: SIZE_XS),
              // Text(currency ?? "INR-₹",
              //     style: const TextStyle(
              //         fontSize: FONT_SM, color: NORMAL_TEXT_CLR)),

              // const SizedBox(height: SIZE_MD),
              // const Text(
              //   'GST Number',
              //   style: TextStyle(fontSize: FONT_XSS, color: SECONDARY_CLR),
              // ),

              // const SizedBox(height: SIZE_XS),
              // Text(gstNumber,
              //     style: TextStyle(
              //         fontSize: gstNumber == NOT_PROVIDED ? FONT_XSS : FONT_SM,
              //         color: gstNumber == NOT_PROVIDED
              //             ? SECONDARY_CLR
              //             : NORMAL_TEXT_CLR)),

              // const SizedBox(
              //   height: SIZE_SM,
              // ),
              // const Divider(
              //   height: 1.0,
              //   color: DIVIDER_COLOR,
              // )
            ],
          ),
        ),
      ),
      source.toUpperCase() == "WEBFORM_"
          ? Positioned(
              bottom: PADDING_XL * 1.6,
              width: MediaQuery.of(context).size.width,
              height: SIZE_LG,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFBBE7FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      _settingModalBottomSheet(context);
                    },
                    child: const Text(
                      'View Source Detail',
                      style: TextStyle(fontSize: SIZE_SM, color: Colors.blue),
                    ),
                  ),
                ),
              ),
            )
          : const SizedBox(),
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
                            onPressed: () async {
                              if (mobileNumber != '') {
                                Uri phoneno = Uri.parse('tel:$mobileNumber');
                                if (await launchUrl(phoneno)) {
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text("Something went wrong!")));
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
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
                          const VerticalDivider(
                            color: BORDER_COLOR,
                          ),
                          const SizedBox(
                            width: SIZE_SM,
                          ),
                          IconButton(
                            onPressed: () async {
                              if (mobileNumber != '') {
                                Uri phoneno = Uri.parse('sms:$mobileNumber');
                                if (await launchUrl(phoneno)) {
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text("Something went wrong!")));
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Phone number is not present!")));
                              }
                            },
                            icon: SvgPicture.asset(
                              "assets/images/messages.svg",
                              width: SIZE_LG,
                              height: SIZE_LG,
                            ),
                          ),
                          const SizedBox(
                            width: SIZE_SM,
                          ),
                          const VerticalDivider(
                            color: BORDER_COLOR,
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
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text("Something went wrong!")));
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Email address is not present!")));
                              }
                            },
                            icon: SvgPicture.asset(
                              "assets/images/mail_outline_ic.svg",
                              width: SIZE_LG,
                              height: SIZE_LG,
                            ),
                          )
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
    ]);
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 600,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(BORDER_RADIUS_LG),
                topRight: Radius.circular(BORDER_RADIUS_LG),
              ),
            ),
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFE2E2),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Close',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 400,
                  color: const Color(0xFFF0F8FF),
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: PADDING_LG),
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    children: [
                      const SizedBox(
                        height: SIZE_SM,
                      ),
                      Text(
                        textAlign: TextAlign.center,
                        'Contact created via $source (Connect with Us)',
                        style: const TextStyle(
                          fontSize: FONT_SM,
                          color: NORMAL_TEXT_CLR,
                        ),
                      ),
                      const SizedBox(
                        height: SIZE_SM,
                      ),
                      const Text(
                        "First Name",
                        style: TextStyle(
                          fontSize: FONT_SM,
                          color: NORMAL_TEXT_CLR,
                        ),
                      ),
                      const SizedBox(
                        height: SIZE_XS,
                      ),
                      Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border:
                                  Border.all(color: BORDER_COLOR, width: 1.0),
                              borderRadius: BorderRadius.circular(4)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: PADDING_XS, horizontal: PADDING_XS),
                            child: Text(firstName),
                          )),
                      const SizedBox(
                        height: SIZE_SM,
                      ),
                      const Text(
                        'Last Name',
                        style: TextStyle(
                          fontSize: FONT_SM,
                          color: NORMAL_TEXT_CLR,
                        ),
                      ),
                      const SizedBox(
                        height: SIZE_XS,
                      ),
                      Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border:
                                  Border.all(color: BORDER_COLOR, width: 1.0),
                              borderRadius: BorderRadius.circular(4)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: PADDING_XS, horizontal: PADDING_XS),
                            child: Text(lastName),
                          )),
                      const SizedBox(
                        height: SIZE_SM,
                      ),
                      const Text(
                        'Phone',
                        style: TextStyle(
                          fontSize: FONT_SM,
                          color: NORMAL_TEXT_CLR,
                        ),
                      ),
                      const SizedBox(
                        height: SIZE_XS,
                      ),
                      Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border:
                                  Border.all(color: BORDER_COLOR, width: 1.0),
                              borderRadius: BorderRadius.circular(4)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: PADDING_XS, horizontal: PADDING_XS),
                            child: Text(mobileNumber),
                          )),
                      const SizedBox(
                        height: SIZE_SM,
                      ),
                      const Text(
                        'Email',
                        style: TextStyle(
                          fontSize: FONT_SM,
                          color: NORMAL_TEXT_CLR,
                        ),
                      ),
                      const SizedBox(
                        height: SIZE_XS,
                      ),
                      Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border:
                                  Border.all(color: BORDER_COLOR, width: 1.0),
                              borderRadius: BorderRadius.circular(4)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: PADDING_XS, horizontal: PADDING_XS),
                            child: Text(emailAddress),
                          )),
                      const SizedBox(
                        height: SIZE_SM,
                      ),
                      const Text(
                        'City',
                        style: TextStyle(
                          fontSize: FONT_SM,
                          color: NORMAL_TEXT_CLR,
                        ),
                      ),
                      const SizedBox(
                        height: SIZE_XS,
                      ),
                      Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border:
                                  Border.all(color: BORDER_COLOR, width: 1.0),
                              borderRadius: BorderRadius.circular(4)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: PADDING_XS, horizontal: PADDING_XS),
                            child: Text(city),
                          )),
                      const SizedBox(
                        height: SIZE_SM,
                      ),
                      const Text(
                        'Company',
                        style: TextStyle(
                          fontSize: FONT_SM,
                          color: NORMAL_TEXT_CLR,
                        ),
                      ),
                      const SizedBox(
                        height: SIZE_XS,
                      ),
                      Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border:
                                  Border.all(color: BORDER_COLOR, width: 1.0),
                              borderRadius: BorderRadius.circular(4)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: PADDING_XS, horizontal: PADDING_XS),
                            child: Text(compName),
                          )),
                      const SizedBox(
                        height: SIZE_SM,
                      ),
                      const Text(
                        'Service Interested',
                        style: TextStyle(
                          fontSize: FONT_SM,
                          color: NORMAL_TEXT_CLR,
                        ),
                      ),
                      const SizedBox(
                        height: SIZE_XS,
                      ),
                      Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border:
                                  Border.all(color: BORDER_COLOR, width: 1.0),
                              borderRadius: BorderRadius.circular(4)),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: PADDING_XS, horizontal: PADDING_XS),
                            child: Text("Others"),
                          )),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}
