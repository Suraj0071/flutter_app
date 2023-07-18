import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/backend/api_manager.dart';
import 'package:flutter_app/constants/constants.dart';
import 'package:flutter_app/modal/detail_feed_model.dart';
import 'package:flutter_app/screens/detail_tab_screens/all_act_screen.dart';
import 'package:flutter_app/screens/detail_tab_screens/buyers_journey_screen.dart';
import 'package:flutter_app/screens/detail_tab_screens/information_screen.dart';
import 'package:flutter_app/screens/nav_screens/contact/new_contact.dart';
import 'package:flutter_app/screens/new_activity.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/widgets/card.dart';
import 'package:flutter_app/screens/call_log.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailScreen extends StatefulWidget {
  final String id, source, name;
  DetailScreen(
      {Key? key, required this.id, required this.source, required this.name})
      : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState(this.id, this.source);
}

class _DetailScreenState extends State<DetailScreen>
    with SingleTickerProviderStateMixin {
  _DetailScreenState(this.id, this.source);
  late TabController _tabController;
  late bool isLoading = false;
  late Future<FeedDetailData> detaildata;
  late List<Activity> activityDetaildata = [];
  late bool hasActivityDetaildata = false;
  late bool hasbuyersJourneyDetaildata = false;
  late List<BuyersJourney> buyersJourneyDetaildata = [];
  String superCustomerID = "";
  String compCode = "", accountId = "", roleId = "";
  String id, source;
  int selectedTabIndex = 1;
  double appBarHeight = AppBar().preferredSize.height;
  bool showElevetion = true;
  String headerTitle = "Detail";

  @override
  void initState() {
    super.initState();
    detaildata = getDetailData();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      setState(() {
        selectedTabIndex = _tabController.index + 1;
      });
    }
  }

  Future<FeedDetailData> getDetailData() async {
    setState(() {
      isLoading = true;
    });
    superCustomerID = await ApiManager(context).getLocalData("super_cust_id");
    compCode = await ApiManager(context).getLocalData("comp_code");
    accountId = await ApiManager(context).getLocalData("account_id");
    roleId = await ApiManager(context).getLocalData("role_id");
    final responseData = await ApiManager(context).getApiData(
        "$BASE_URL/detail_data?source=$source&id=$id&super_customer_id=$superCustomerID&comp_code=$compCode&acc_id=$accountId&role=$roleId");
    // print(
    //     "$BASE_URL/detail_data?source=$source&id=$id&super_customer_id=$superCustomerID&comp_code=$compCode&acc_id=$accountId&role=$roleId");

    if (responseData != null) {
      setState(() {
        isLoading = false;
      });
      if (responseData["activity"] != null) {
        setState(() {
          hasActivityDetaildata = true;
        });
        for (var i in responseData["activity"]) {
          activityDetaildata.add(Activity.fromJson(i));
        }
      }
      if (responseData["buyers_journey"] != null) {
        setState(() {
          hasbuyersJourneyDetaildata = true;
        });
        for (var i in responseData["buyers_journey"]) {
          buyersJourneyDetaildata.add(BuyersJourney.fromJson(i));
        }
      }
      return FeedDetailData.fromJson(responseData);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> _updateLeadScreen(BuildContext context) async {
    final res = await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => NewContact(
          id: id,
        ),
      ),
    );
    // setState(() {

    if (res == 'Y') {
      activityDetaildata.clear();
      buyersJourneyDetaildata.clear();
      detaildata = getDetailData();
    }
    // });

    if (!mounted) return;
  }

  Future<void> _addActivityScreen(
      BuildContext context, leadId, leadName, cntOwnId, cntOwnName) async {
    final res = await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => NewActivity(
          cntId: leadId,
          cntName: leadName,
          leadOwnerId: cntOwnId,
          leadOwnerName: cntOwnName,
        ),
      ),
    );
    // setState(() {

    if (res == 'Y') {
      activityDetaildata.clear();
      buyersJourneyDetaildata.clear();
      detaildata = getDetailData();
    }
    // });

    if (!mounted) return;
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  String getHeaderImage(status) {
    if (status == "create") {
      return 'assets/images/create_lead_card_ic.svg';
    }
    return 'assets/images/update_lead_card_ic.svg';
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          headerTitle,
          style: const TextStyle(color: Colors.black),
        ),
        elevation: showElevetion ? 2.6 : 0,
        actions: [
          TextButton(
            onPressed: () {
              _updateLeadScreen(context);
            },
            child: const Text(
              "Edit",
              style: TextStyle(fontSize: FONT_XSS, color: DARK_TEXT_CLR),
            ),
          ),
        ],
      ),
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            // print(innerBoxIsScrolled);
            // if (innerBoxIsScrolled == true) {
            //   setState(() {
            //     showElevetion = false;
            //     headerTitle = widget.name;
            //   });
            // } else {
            //   setState(() {
            //     showElevetion = true;
            //     headerTitle = "Detail";
            //   });
            // }
            return [
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  pinned: true,
                  automaticallyImplyLeading: false,
                  expandedHeight: size.height * 0.4,
                  toolbarHeight: 0,
                  title: innerBoxIsScrolled
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: SvgPicture.asset(
                                "assets/images/call_detail_header_ic.svg",
                                height: SIZE_LG + 10,
                              ),
                            ),
                            const SizedBox(width: SIZE_SM),
                            SvgPicture.asset(
                              "assets/images/msg_detail_header_ic.svg",
                              height: SIZE_LG + 10,
                            ),
                            const SizedBox(width: SIZE_SM),
                            SvgPicture.asset(
                              "assets/images/mail_detail_header_ic.svg",
                              height: SIZE_LG + 10,
                            ),
                            const SizedBox(width: SIZE_SM),
                            GestureDetector(
                              onTap: () {
                                _taskBottomSheet(context);
                              },
                              child: SvgPicture.asset(
                                "assets/images/create_task_detail_ic.svg",
                                height: SIZE_LG + 10,
                              ),
                            ),
                          ],
                        )
                      : SizedBox(),
                  centerTitle: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      children: [
                        SizedBox(
                          width: size.width,
                          height: size.height * 0.4,
                          child: Image.asset(
                            'assets/images/icon.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        offset: const Offset(5, 9),
                                        spreadRadius: 2,
                                        blurRadius: 13,
                                        color: Colors.grey.withOpacity(.05),
                                      ),
                                    ],
                                  ),
                                  child: FutureBuilder<FeedDetailData>(
                                    future: detaildata,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return SvgPicture.asset(
                                          getHeaderImage(snapshot
                                              .data!.information!.createUpdate
                                              .toString()),
                                        );
                                      }
                                      return const Text('');
                                    },
                                  ),
                                ),
                                const SizedBox(height: SIZE_SM),
                                FutureBuilder<FeedDetailData>(
                                  future: detaildata,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Column(
                                        children: [
                                          Text(
                                            snapshot.data!.information!
                                                        .firstName
                                                        .toString() ==
                                                    ""
                                                ? snapshot
                                                    .data!.information!.lastName
                                                    .toString()
                                                : "${snapshot.data!.information!.firstName ?? ""} ${snapshot.data!.information!.lastName}",
                                            style: const TextStyle(
                                                fontSize: FONT_MD),
                                          ),
                                          Text(
                                            "Last Activity ${snapshot.data!.information!.lastActivity}",
                                            style: const TextStyle(
                                              fontSize: FONT_XS,
                                              color: SECONDARY_CLR,
                                            ),
                                          ),
                                        ],
                                      );
                                    } else if (snapshot.hasError) {
                                      return const Center(
                                        child: Text(
                                            'Some error occurred! Please try again later.'),
                                      );
                                    }
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        color: NORMAL_TEXT_CLR,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: PADDING_SM,
                              ),
                              child: FutureBuilder<FeedDetailData>(
                                  future: detaildata,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              if (snapshot.data!.information!
                                                      .mobileNo !=
                                                  '') {
                                                Uri phoneno = Uri.parse(
                                                    'tel:${snapshot.data!.information!.mobileNo}');
                                                if (await launchUrl(phoneno)) {
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(const SnackBar(
                                                          content: Text(
                                                              "Something went wrong!")));
                                                }
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        content: Text(
                                                            "Phone number is not present!")));
                                              }
                                            },
                                            child: SvgPicture.asset(
                                              "assets/images/call_detail_header_ic.svg",
                                              height: SIZE_LG + 10,
                                            ),
                                          ),
                                          const SizedBox(width: SIZE_SM),
                                          GestureDetector(
                                            onTap: () async {
                                              if (snapshot.data!.information!
                                                      .mobileNo !=
                                                  '') {
                                                Uri phoneno = Uri.parse(
                                                    'sms:${snapshot.data!.information!.mobileNo}');
                                                if (await launchUrl(phoneno)) {
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(const SnackBar(
                                                          content: Text(
                                                              "Something went wrong!")));
                                                }
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        content: Text(
                                                            "Phone number is not present!")));
                                              }
                                            },
                                            child: SvgPicture.asset(
                                              "assets/images/msg_detail_header_ic.svg",
                                              height: SIZE_LG + 10,
                                            ),
                                          ),
                                          const SizedBox(width: SIZE_SM),
                                          GestureDetector(
                                            onTap: () async {
                                              if (snapshot.data!.information!
                                                      .email !=
                                                  '') {
                                                Uri emailLaunch = Uri.parse(
                                                    'mailto:${snapshot.data!.information!.email}');
                                                if (await launchUrl(
                                                    emailLaunch)) {
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(const SnackBar(
                                                          content: Text(
                                                              "Something went wrong!")));
                                                }
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        content: Text(
                                                            "Email address is not present!")));
                                              }
                                            },
                                            child: SvgPicture.asset(
                                              "assets/images/mail_detail_header_ic.svg",
                                              height: SIZE_LG + 10,
                                            ),
                                          ),
                                          const SizedBox(width: SIZE_SM),
                                          GestureDetector(
                                            onTap: () {
                                              _taskBottomSheet(context);
                                            },
                                            child: SvgPicture.asset(
                                              "assets/images/create_task_detail_ic.svg",
                                              height: SIZE_LG + 10,
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                    return SizedBox();
                                  }),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  bottom: TabBar(
                    unselectedLabelColor: UNSELECTED_TAB_CLR,
                    padding: const EdgeInsets.symmetric(horizontal: PADDING_SM),
                    labelPadding: EdgeInsets.zero,
                    labelColor: SELECTED_TAB_CLR,
                    indicator: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: SELECTED_TAB_CLR, // Active tab border color
                          width: 2.0, // Border width
                        ),
                      ),
                    ),
                    tabs: [
                      Tab(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.26,
                          child: Center(
                            child: Text(
                              'Information',
                              maxLines: 1,
                              style: TextStyle(
                                fontSize:
                                    selectedTabIndex == 1 ? FONT_XSS : FONT_XS,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Tab(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.26,
                          child: Center(
                            child: Text(
                              'All Activities',
                              maxLines: 1,
                              style: TextStyle(
                                fontSize:
                                    selectedTabIndex == 2 ? FONT_XSS : FONT_XS,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          "Buyer's Journey",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize:
                                selectedTabIndex == 3 ? FONT_XSS : FONT_XS,
                          ),
                        ),
                      ),
                    ],
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                  ),
                ),
              ),
            ];
          },
          body: Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.06),
            child: TabBarView(
              children: [
                FutureBuilder<FeedDetailData>(
                  future: detaildata,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return InformationTab(
                        firstName: snapshot.data!.information!.firstName ?? "",
                        lastName: snapshot.data!.information!.lastName ?? "",
                        fullName:
                            "${snapshot.data!.information!.firstName} ${snapshot.data!.information!.lastName}",
                        compName:
                            snapshot.data!.information!.company ?? NOT_PROVIDED,
                        compAnnualTurnover:
                            snapshot.data!.information!.annualTurnover ??
                                NOT_PROVIDED,
                        compPhone: snapshot.data!.information!.workPhone ??
                            NOT_PROVIDED,
                        compWebsite:
                            snapshot.data!.information!.website ?? NOT_PROVIDED,
                        emailAddress:
                            snapshot.data!.information!.email ?? NOT_PROVIDED,
                        gstNumber: snapshot.data!.information!.gstNumber ??
                            NOT_PROVIDED,
                        leadOwner: snapshot.data!.information!.leadOwner ??
                            NOT_PROVIDED,
                        mobileNumber: snapshot.data!.information!.mobileNo ??
                            NOT_PROVIDED,
                        currency: snapshot.data!.information!.countryCode ??
                            NOT_PROVIDED,
                        source: snapshot.data!.information!.leadSource ??
                            NOT_PROVIDED,
                        city: snapshot.data!.information!.city ?? NOT_PROVIDED,
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                            'Some error occurred! Please try again later.'),
                      );
                    }
                    // By default, show a loading spinner.
                    return const Center(
                      child: CircularProgressIndicator(
                        color: NORMAL_TEXT_CLR,
                      ),
                    );
                  },
                ),
                AllActivityTab(
                  hasData: hasActivityDetaildata,
                  data: activityDetaildata,
                  total: activityDetaildata.length,
                ),
                FutureBuilder<FeedDetailData>(
                  future: detaildata,
                  builder: (context, snapshot) {
                    return BuyersJourneyTab(
                      hasData: hasActivityDetaildata,
                      data: buyersJourneyDetaildata,
                      total: buyersJourneyDetaildata.length,
                      leadSource: snapshot.data?.information?.leadSource ??
                          "No record found!",
                    );
                  },
                ),
              ],
              controller: _tabController,
            ),
          ),
        ),
      ),
    );
  }

  void _taskBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: false,
        backgroundColor: Color(0xFFFAFAFA),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(BORDER_RADIUS_LG),
              topLeft: Radius.circular(BORDER_RADIUS_LG) //),
              ),
        ),
        builder: (BuildContext context) {
          return Container(
            height: 200,
            child: Column(
              children: [
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(vertical: PADDING_SM),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(BORDER_RADIUS_LG),
                        topLeft: Radius.circular(BORDER_RADIUS_LG)),
                    color: BTMSHEET_CLOSE_BG_CLR,
                  ),
                  child: const Center(
                      child: Text(
                    "Add New",
                    style: TextStyle(
                        color: DARK_TEXT_CLR,
                        fontSize: FONT_APPBAR_TITLE,
                        fontFamily: 'MatteoBold'),
                  )),
                ),
                FutureBuilder<FeedDetailData>(
                    future: detaildata,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return InkWell(
                          onTap: () {
                            // Button action
                            Navigator.pop(context);
                            _addActivityScreen(
                                context,
                                widget.id,
                                widget.name,
                                snapshot.data!.information!.leadOwnerId,
                                snapshot.data!.information!.leadOwner);
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => NewActivity(
                            // cntId: widget.id,
                            // cntName: widget.name,
                            // leadOwnerId: snapshot
                            //     .data!.information!.leadOwnerId,
                            // leadOwnerName: snapshot
                            //     .data!.information!.leadOwner,
                            //           )),
                            // );
                          },
                          highlightColor: BTN_HOVER_CLR,
                          child: Container(
                            height: 50,
                            padding: const EdgeInsets.all(PADDING_SM),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                    "assets/images/add_task_bs_ic.svg"),
                                const SizedBox(width: SIZE_SM),
                                const Text(
                                  "Activity",
                                  style: TextStyle(
                                      color: DARK_TEXT_CLR, fontSize: FONT_SM),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(
                          color: NORMAL_TEXT_CLR,
                        ),
                      );
                    }),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: PADDING_SM),
                  child: Divider(
                    thickness: 1,
                    color: DIVIDER_COLOR,
                  ),
                ),
                // InkWell(
                //   onTap: () {
                //     // Button action
                //   },
                //   highlightColor: BTN_HOVER_CLR,
                //   child: Container(
                //     padding: const EdgeInsets.all(PADDING_SM),
                //     child: Row(
                //       children: [
                //         SvgPicture.asset("assets/images/add_deal_bs_ic.svg"),
                //         const SizedBox(width: SIZE_SM),
                //         const Text(
                //           "Deal",
                //           style:
                //               TextStyle(color: DARK_TEXT_CLR, fontSize: FONT_SM),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // const Padding(
                //   padding: EdgeInsets.symmetric(horizontal: PADDING_SM),
                //   child: Divider(
                //     thickness: 1,
                //     color: DIVIDER_COLOR,
                //   ),
                // ),
                // InkWell(
                //   onTap: () {
                //     // Button action
                //   },
                //   highlightColor: BTN_HOVER_CLR,
                //   child: Container(
                //     padding: const EdgeInsets.all(PADDING_SM),
                //     child: Row(
                //       children: [
                //         SvgPicture.asset("assets/images/add_notes_bs_ic.svg"),
                //         const SizedBox(width: SIZE_SM),
                //         const Text(
                //           "Note",
                //           style:
                //               TextStyle(color: DARK_TEXT_CLR, fontSize: FONT_SM),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // const Padding(
                //   padding: EdgeInsets.symmetric(horizontal: PADDING_SM),
                //   child: Divider(
                //     thickness: 1,
                //     color: DIVIDER_COLOR,
                //   ),
                // ),
                // InkWell(
                //   onTap: () {
                //     // Button action
                //   },
                //   highlightColor: BTN_HOVER_CLR,
                //   child: Container(
                //     padding: const EdgeInsets.all(PADDING_SM),
                //     child: Row(
                //       children: [
                //         SvgPicture.asset(
                //             "assets/images/add_attachment_bs_ic.svg"),
                //         const SizedBox(width: SIZE_SM),
                //         const Text(
                //           "Attachments",
                //           style:
                //               TextStyle(color: DARK_TEXT_CLR, fontSize: FONT_SM),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // const Padding(
                //   padding: EdgeInsets.symmetric(horizontal: PADDING_SM),
                //   child: Divider(
                //     thickness: 1,
                //     color: DIVIDER_COLOR,
                //   ),
                // ),
                // InkWell(
                //   onTap: () {
                //     // Button action
                //   },
                //   highlightColor: BTN_HOVER_CLR,
                //   child: Container(
                //     padding: const EdgeInsets.all(PADDING_SM),
                //     child: Row(
                //       children: [
                //         SvgPicture.asset("assets/images/add_geoloc_bs_ic.svg"),
                //         const SizedBox(width: SIZE_SM),
                //         const Text(
                //           "GEO Location",
                //           style:
                //               TextStyle(color: DARK_TEXT_CLR, fontSize: FONT_SM),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // const Padding(
                //   padding: EdgeInsets.symmetric(horizontal: PADDING_SM),
                //   child: Divider(
                //     thickness: 1,
                //     color: DIVIDER_COLOR,
                //   ),
                // ),
                Container(
                  width: double.infinity,
                  height: 50,
                  margin: const EdgeInsets.symmetric(horizontal: SIZE_MD),
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
}
