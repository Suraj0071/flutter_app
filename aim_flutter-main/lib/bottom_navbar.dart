import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/backend/api_manager.dart';
import 'package:flutter_app/constants/constants.dart';
import 'package:flutter_app/modal/call_log_model.dart';
import 'package:flutter_app/screens/call_log.dart';
import 'package:flutter_app/screens/detail_screen.dart';
import 'package:flutter_app/screens/home_screen.dart';
import 'package:flutter_app/screens/nav_screens/contact_screen.dart';
import 'package:flutter_app/screens/nav_screens/feed_screen.dart';
import 'package:flutter_app/screens/nav_screens/focus_screen.dart';
import 'package:flutter_app/screens/nav_screens/more_screen.dart';
import 'package:flutter_app/screens/nav_screens/opportunity_screen.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  List<CallLogEntry> entries = [];
  String superCustomerID = "", compCode = "", accountId = "", roleId = "";
  var responseData;
  String callLogEntriesJson = "";
  PersistentTabController _navController =
      PersistentTabController(initialIndex: 0);

  checkAndrequestPermission(context) async {
    superCustomerID = await ApiManager(context).getLocalData("super_cust_id");
    compCode = await ApiManager(context).getLocalData("comp_code");
    accountId = await ApiManager(context).getLocalData("account_id");
    roleId = await ApiManager(context).getLocalData("role_id");

    var status = await Permission.contacts.isGranted;

    responseData = await ApiManager(context).getApiData(
        "$BASE_URL/last-call-log-time?super_cust_id=$superCustomerID&comp_code=$compCode&acc_id=$accountId");
    final lastTime = responseData['last_time'];
    print(lastTime);
    if (status) {
      entries = await CallLog.get();
      if (lastTime == 'ALL') {
        List<Map<String, dynamic>> jsonList = entries
            .map<Map<String, dynamic>>((entry) => entry.toJson())
            .toList();

        callLogEntriesJson = jsonEncode(jsonList);
        sendContactsToDB(callLogEntriesJson);
      } else {
        // DateFormat format = DateFormat('dd-MM-yyyy HH:mm:ss');
        // DateTime dateTime = format.parse(lastTime);
        // int maxTimeStamp = dateTime.millisecondsSinceEpoch ~/ 1000;
        List<Map<String, dynamic>> jsonList = entries
            .where((entry) {
              if (entry.timestampUnix != null) {
                int entryTimestamp = entry.timestampUnix!;
                if (entryTimestamp > int.parse(lastTime)) return true;
              }
              return false;
            })
            .map<Map<String, dynamic>>((entry) => entry.toJson())
            .toList();
        callLogEntriesJson = jsonEncode(jsonList);
        sendContactsToDB(callLogEntriesJson);
      }
    } else {
      //denied
    }
  }

  void requestPermission() async {
    if (await Permission.contacts.isGranted) {
      checkAndrequestPermission(context);
      return;
    }

    await Permission.contacts.request();
    if (await Permission.contacts.isDenied) return;
    checkAndrequestPermission(context);
  }

  @override
  void dispose() {
    _navController.dispose();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.dispose();
  }

  void sendContactsToDB(String callLogs) async {
    print(callLogs);
    try {
      final response = await http.post(
        Uri.parse(
          "$BASE_URL/call-logs?super_cust_id=$superCustomerID&comp_code=$compCode&acc_id=$accountId&role_id=$roleId",
        ),
        body: callLogs,
      );

      if (response.statusCode == 200) {
        print('Call logs sent successfully.');
        DateTime now = DateTime.now();
        String formattedDateTime = DateFormat('MMM d, yyyy-h:mm a').format(now);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('lastCallLogSyncTime', formattedDateTime);
      } else {
        print('Failed to send call logs. StatusCode: ${response.statusCode}');
      }
    } catch (error) {
      print('Error occurred while sending call logs: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid)
      requestPermission(); //checkAndrequestPermission(context);
    // ApiManager(context).checkAndrequestPermission(context);
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      padding: const NavBarPadding.only(
          top: PADDING_SM, bottom: 0, left: 0, right: 0),
      context,
      navBarHeight: BOTTOM_NAV_HEIGHT,
      controller: _navController,
      screens: _buildScreens(),
      items: _navBarsItems(),
      onItemSelected: (value) {
        FocusScope.of(context).unfocus();
      },
      popAllScreensOnTapAnyTabs: true,
      confineInSafeArea: true,
      backgroundColor: BOTTOM_NAV_BG,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(SIZE_SM),
        colorBehindNavBar: Colors.white,
        boxShadow: [
          BoxShadow(
            color: BLUR_COLOR.withOpacity(0.76),
            blurRadius: 25.0, // soften the shadow
            spreadRadius: -5.0, //extend the shadow
            offset: const Offset(
              -3.0, // Move to right 10 horizontally
              5.0, // Move to bottom 10 Vertically
            ),
          ),
        ],
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.simple,
    );
  }
}

List<Widget> _buildScreens() {
  return [
    // const FocusScreen(),
    const FeedScreen(),
    // const OpportunityScreen(),
    const ContactScreen(),
    const MoreScreen()
  ];
}

List<PersistentBottomNavBarItem> _navBarsItems() {
  return [
    // PersistentBottomNavBarItem(
    //   inactiveIcon: Column(
    //     children: [
    //       SvgPicture.asset(
    //         "assets/images/bottom_nav_ic/focus_nav_ic.svg",
    //         color: BOTTOM_NAV_UNSELECTED,
    //       ),
    //       const Text(
    //         "Focus",
    //         style: TextStyle(
    //             fontSize: FONT_XS,
    //             color: BOTTOM_NAV_UNSELECTED,
    //             decoration: TextDecoration.none,
    //             fontWeight: FontWeight.normal,
    //             fontFamily: 'Matteo'),
    //         maxLines: 1,
    //         overflow: TextOverflow.ellipsis,
    //       )
    //     ],
    //   ),
    //   icon: Column(
    //     children: [
    //       SvgPicture.asset(
    //         "assets/images/bottom_nav_ic/focus_nav_ic.svg",
    //         color: BOTTOM_NAV_SELECTED,
    //       ),
    //       const Text(
    //         "Focus",
    //         style: TextStyle(
    //             fontSize: FONT_XS,
    //             color: BOTTOM_NAV_SELECTED,
    //             decoration: TextDecoration.none,
    //             fontWeight: FontWeight.normal,
    //             fontFamily: 'Matteo'),
    //         maxLines: 1,
    //         overflow: TextOverflow.ellipsis,
    //       )
    //     ],
    //   ),
    //   // title: "Focus",
    //   activeColorPrimary: BOTTOM_NAV_SELECTED,
    //   inactiveColorPrimary: BOTTOM_NAV_UNSELECTED,
    // ),
    PersistentBottomNavBarItem(
      // icon: const Icon(CupertinoIcons.tv),
      inactiveIcon: Column(
        children: [
          SvgPicture.asset(
            "assets/images/bottom_nav_ic/my_feeds_nav_ic.svg",
            color: BOTTOM_NAV_UNSELECTED,
          ),
          const Text(
            "My Feeds",
            style: TextStyle(
                fontSize: FONT_XS,
                color: BOTTOM_NAV_UNSELECTED,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.normal,
                fontFamily: 'Matteo'),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
      icon: Column(
        children: [
          SvgPicture.asset(
            "assets/images/bottom_nav_ic/my_feeds_nav_ic.svg",
            color: BOTTOM_NAV_SELECTED,
          ),
          const Text(
            "My Feeds",
            style: TextStyle(
                fontSize: FONT_XS,
                color: BOTTOM_NAV_SELECTED,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.normal,
                fontFamily: 'Matteo'),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
      activeColorPrimary: BOTTOM_NAV_SELECTED,
      inactiveColorPrimary: BOTTOM_NAV_UNSELECTED,
    ),
    // PersistentBottomNavBarItem(
    //   inactiveIcon: Column(
    //     children: [
    //       SvgPicture.asset(
    //         "assets/images/bottom_nav_ic/opportunity_nav_ic.svg",
    //         color: BOTTOM_NAV_UNSELECTED,
    //       ),
    //       const Text(
    //         "Opportunity",
    //         style: TextStyle(
    //             fontSize: FONT_XS,
    //             color: BOTTOM_NAV_UNSELECTED,
    //             decoration: TextDecoration.none,
    //             fontWeight: FontWeight.normal,
    //             fontFamily: 'Matteo'),
    //         maxLines: 1,
    //         overflow: TextOverflow.ellipsis,
    //       )
    //     ],
    //   ),
    //   icon: Column(
    //     children: [
    //       SvgPicture.asset(
    //         "assets/images/bottom_nav_ic/opportunity_nav_ic.svg",
    //         color: BOTTOM_NAV_SELECTED,
    //       ),
    //       const Text(
    //         "Opportunity",
    //         style: TextStyle(
    //             fontSize: FONT_XS,
    //             color: BOTTOM_NAV_SELECTED,
    //             decoration: TextDecoration.none,
    //             fontWeight: FontWeight.normal,
    //             fontFamily: 'Matteo'),
    //         maxLines: 1,
    //         overflow: TextOverflow.ellipsis,
    //       )
    //     ],
    //   ),
    //   activeColorPrimary: BOTTOM_NAV_SELECTED,
    //   inactiveColorPrimary: BOTTOM_NAV_UNSELECTED,
    // ),
    PersistentBottomNavBarItem(
      inactiveIcon: Column(
        children: [
          SvgPicture.asset(
            "assets/images/bottom_nav_ic/contact_nav_ic.svg",
            color: BOTTOM_NAV_UNSELECTED,
          ),
          const Text(
            "Contacts",
            style: TextStyle(
                fontSize: FONT_XS,
                color: BOTTOM_NAV_UNSELECTED,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.normal,
                fontFamily: 'Matteo'),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
      icon: Column(
        children: [
          SvgPicture.asset(
            "assets/images/bottom_nav_ic/contact_nav_ic.svg",
            color: BOTTOM_NAV_SELECTED,
          ),
          const Text(
            "Contacts",
            style: TextStyle(
                fontSize: FONT_XS,
                color: BOTTOM_NAV_SELECTED,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.normal,
                fontFamily: 'Matteo'),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
      activeColorPrimary: BOTTOM_NAV_SELECTED,
      inactiveColorPrimary: BOTTOM_NAV_UNSELECTED,
    ),
    PersistentBottomNavBarItem(
      inactiveIcon: Column(
        children: [
          SvgPicture.asset(
            "assets/images/bottom_nav_ic/more_nav_ic.svg",
            color: BOTTOM_NAV_UNSELECTED,
          ),
          const Text(
            "More",
            style: TextStyle(
                fontSize: FONT_XS,
                color: BOTTOM_NAV_UNSELECTED,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.normal,
                fontFamily: 'Matteo'),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
      icon: Column(
        children: [
          SvgPicture.asset(
            "assets/images/bottom_nav_ic/more_nav_ic.svg",
            color: BOTTOM_NAV_SELECTED,
          ),
          const Text(
            "More",
            style: TextStyle(
                fontSize: FONT_XS,
                color: BOTTOM_NAV_SELECTED,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.normal,
                fontFamily: 'Matteo'),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
      activeColorPrimary: BOTTOM_NAV_SELECTED,
      inactiveColorPrimary: BOTTOM_NAV_UNSELECTED,
    ),
  ];
}
