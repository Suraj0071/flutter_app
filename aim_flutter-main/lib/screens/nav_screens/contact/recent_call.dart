import 'dart:io';

import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_app/backend/api_manager.dart';
import 'package:flutter_app/constants/constants.dart';
import 'package:flutter_app/modal/cal_log_data_model.dart';
import 'package:flutter_app/screens/call_log.dart';
import 'package:flutter_app/screens/call_summary.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/route_manager.dart';
import 'package:get/utils.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecentCall extends StatefulWidget {
  const RecentCall({super.key});

  @override
  State<RecentCall> createState() => _RecentCallState();
}

class _RecentCallState extends State<RecentCall> {
  String? dropdownValue = 'Recent Calls';
  double appBarHeight = AppBar().preferredSize.height;

  List<CallLogDataItem> entries = [];
  List<CallLogDataItem> missedLogs = [];
  bool isLoading = false;
  bool isReqGranted = false;
  var responseLogs;
  String superCustomerID = "",
      compCode = "",
      accountId = "",
      roleId = "",
      paginationUrl = "";
  bool hasMoreData = true, isPaginationLoading = false;
  String selectedTab = 'A';
  String? lastSyncedTime;
  bool _isDialogOpen = false;

  final ScrollController _scrollController = ScrollController();

  checkIsGrantedReq() async {
    var status = await Permission.contacts.isGranted;
    if (status) {
      _scrollController.addListener(() {
        if (_scrollController.position.atEdge) {
          bool isTop = _scrollController.position.pixels == 0;
          if (!isTop) {
            setState(() {
              if (paginationUrl != "" || paginationUrl != null) {
                isPaginationLoading = true;
                getCallLogs();
              }
            });
          }
        }
      });

      getCallLogs();
      setState(() {
        isReqGranted = true;
        isLoading = false;
        isPaginationLoading = false;
      });
    } else {
      isReqGranted = false;
      setState(() {
        isLoading = false;
      });
    }
  }

  void getLastSyncTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    lastSyncedTime = prefs.getString('lastCallLogSyncTime');
    if (lastSyncedTime != null) {
      DateTime now = DateTime.now();
      String formattedDateNow = DateFormat('MMM d, yyyy').format(now);

      final lastSyncDateTime = lastSyncedTime!.split('-');
      final lastDate = lastSyncDateTime[0];
      final lastTime = lastSyncDateTime[1];
      if (formattedDateNow == lastDate) {
        setState(() {
          lastSyncedTime = 'Last Sync at: $lastTime';
        });
      } else {
        setState(() {
          lastSyncedTime = 'Last Sync on: $lastDate $lastTime';
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      isLoading = true;
    });
    getLastSyncTime();
    checkIsGrantedReq();
  }

  void getCallLogs() async {
    superCustomerID = await ApiManager(context).getLocalData("super_cust_id");
    compCode = await ApiManager(context).getLocalData("comp_code");
    accountId = await ApiManager(context).getLocalData("account_id");
    roleId = await ApiManager(context).getLocalData("role_id");

    if (!hasMoreData) return;

    if (paginationUrl == "") {
      responseLogs = await ApiManager(context).getApiData(
          "$BASE_URL/call-logs?super_cust_id=$superCustomerID&comp_code=$compCode&acc_id=$accountId");
    } else if (hasMoreData) {
      responseLogs = await ApiManager(context).getApiData(paginationUrl);
    }
    if (responseLogs != null) {
      setState(() {
        for (var i in responseLogs["items"]) {
          entries.add(CallLogDataItem.fromJson(i));

          if (CallLogDataItem.fromJson(i).cntStatus == 'M') {
            missedLogs.add(CallLogDataItem.fromJson(i));
          }
        }
        if (responseLogs["hasMore"]) {
          hasMoreData = true;
          for (var i in responseLogs["links"]) {
            if (i["rel"] == "next") {
              paginationUrl = i["href"];
            }
          }
        } else {
          hasMoreData = false;
        }
        isLoading = false;
        isPaginationLoading = false;
      });
    }
  }

  void _showBottomSheet(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double topMarginSheet = statusBarHeight + appBarHeight - 10;
    setState(() {
      _isDialogOpen = true;
    });
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: EdgeInsets.only(top: topMarginSheet),
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
            child: Material(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading:
                        SvgPicture.asset("assets/images/recent_calls_ic.svg"),
                    title: const Text('Recent Calls'),
                    onTap: () {
                      setState(() {
                        dropdownValue = 'Recent Calls';
                      });
                      Navigator.pop(context);
                    },
                    trailing:
                        SvgPicture.asset("assets/images/tick_contact_ic.svg"),
                  ),
                  ListTile(
                    leading:
                        SvgPicture.asset("assets/images/all_contact_ic.svg"),
                    title: const Text(
                      'All Contacts',
                    ),
                    onTap: () {
                      setState(() {
                        dropdownValue = 'All Contacts';
                      });
                      Navigator.pop(context);
                      Navigator.pop(context);
                      //print('ALL CONTACTS');
                    },
                  ),
                  // Add more list tiles for additional options
                ],
              ),
            ),
          ),
        );
      },
    ).then((value) {
      setState(() {
        _isDialogOpen = false;
      });
    });
  }

// "assets/images/incoming_icon.svg"
  String getCallStatusImg(status) {
    if (status == 'I') return "assets/images/incoming_icon.svg";
    if (status == 'O') return "assets/images/call_outgoing_ic.svg";
    if (status == 'M') return "assets/images/missed_call_icon.svg";
    if (status == 'R') return "assets/images/reject_icon.svg";
    return "assets/images/incoming_icon.svg";
  }

  String getDuration(secs) {
    if (secs == "" || secs == null) return "";
    int minutes = (int.parse(secs) / 60).floor();
    int seconds = int.parse(secs) % 60;

    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Color selectedTabClr = Color(0xFFE9E5FF);
    Color selectedTabTextClr = Color(0xFF5E52AE);
    Color notSelectedTabClr = Color(0xFFF1F0F4);
    Color notSelectedTextTabClr = Color(0xFFB9B9DD);
    double tabRadius = 4.0;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: TextButton(
            onPressed: () {
              _showBottomSheet(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Recent Calls',
                    style: TextStyle(
                        fontSize: FONT_APPBAR_TITLE, color: APPBAR_TXT_CLR)),
                const SizedBox(
                  width: 8,
                ),
                _isDialogOpen
                    ? SvgPicture.asset("assets/images/arrow_up_header_ic.svg")
                    : SvgPicture.asset("assets/images/arrow_down_header_ic.svg")
              ],
            ),
          ),
          actions: [
            IconButton(
              onPressed: null,
              icon: SvgPicture.asset(
                "assets/images/add_icon.svg",
                color: Colors.white,
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(PADDING_XL),
            child: Container(
              width: size.width * 0.46,
              height: 40,
              margin: EdgeInsets.symmetric(
                  horizontal: size.width * 0.27, vertical: 4),
              decoration: BoxDecoration(
                  color: notSelectedTabClr,
                  borderRadius: BorderRadius.all(Radius.circular(tabRadius))),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedTab = 'A';
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: selectedTab == 'A'
                              ? selectedTabClr
                              : Colors.transparent,
                          borderRadius: selectedTab == 'A'
                              ? BorderRadius.all(Radius.circular(tabRadius))
                              : BorderRadius.only(
                                  topLeft: Radius.circular(tabRadius),
                                  bottomLeft: Radius.circular(tabRadius))),
                      width: size.width * 0.23,
                      child: Center(
                          child: Text(
                        'All',
                        style: TextStyle(
                            color: selectedTab == 'A'
                                ? selectedTabTextClr
                                : notSelectedTextTabClr),
                      )),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedTab = 'M';
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: selectedTab == 'M'
                              ? selectedTabClr
                              : Colors.transparent,
                          borderRadius: selectedTab == 'M'
                              ? BorderRadius.all(Radius.circular(tabRadius))
                              : BorderRadius.only(
                                  topRight: Radius.circular(tabRadius),
                                  bottomRight: Radius.circular(tabRadius))),
                      width: size.width * 0.23,
                      child: Center(
                          child: Text(
                        'Missed',
                        style: TextStyle(
                            color: selectedTab == 'M'
                                ? selectedTabTextClr
                                : notSelectedTextTabClr),
                      )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Platform.isAndroid
            ? isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: NORMAL_TEXT_CLR),
                  )
                : !isReqGranted
                    ? Center(
                        child: ElevatedButton(
                            onPressed: () async {
                              var status = await Permission.contacts.request();
                              if (status.isGranted) {
                                getCallLogs();
                              } else {
                                Get.snackbar(
                                  "Call log permission denied!",
                                  "Please give call log permission in order to access call logs",
                                  colorText: DARK_ERROR_COLOR,
                                  backgroundColor: LIGHT_ERROR_COLOR,
                                  icon: const Icon(
                                    Icons.error,
                                    color: DARK_ERROR_COLOR,
                                  ),
                                );
                              }
                            },
                            child: const Text("Request Permission")),
                      )
                    : selectedTab == 'A'
                        ? Column(
                            children: [
                              lastSyncedTime != null
                                  ? Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 12),
                                      color: FILTER_BG,
                                      child: Text(
                                        lastSyncedTime ?? "",
                                        style: const TextStyle(
                                            fontSize: FONT_XSS,
                                            color: APPBAR_TXT_CLR),
                                      ))
                                  : const SizedBox(),
                              Expanded(
                                // height: MediaQuery.of(context).size.height -
                                //     50 -
                                //     PADDING_XL -
                                //     appBarHeight,
                                child: ListView.builder(
                                    controller: _scrollController,
                                    itemCount: entries.length,
                                    padding: const EdgeInsets.all(PADDING_SM),
                                    itemBuilder: (context, index) {
                                      var entry = entries[index];
                                      return ListTile(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CallSummary(
                                                      callLogId: entry.id,
                                                    )),
                                          );
                                        },
                                        leading: SvgPicture.asset(
                                          "assets/images/profile_icon.svg",
                                          width: SIZE_LG + 4,
                                          height: SIZE_LG + 4,
                                        ),
                                        title: Text(
                                          entry.cntName ??
                                              entry.cntNumber ??
                                              'Unknown',
                                          maxLines: 1,
                                          style: TextStyle(
                                              color: entry.cntStatus == 'M'
                                                  ? DARK_ERROR_COLOR
                                                  : NORMAL_TEXT_CLR),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        subtitle: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            // Text('${entry.cntStatus}')
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                  getCallStatusImg(
                                                      entry.cntStatus),
                                                ),
                                                const Text('Phone'),
                                                const SizedBox(
                                                    width:
                                                        5), // Adjust the spacing between the text and the image
                                                Text(entry.cntStatus != 'M'
                                                    ? "• ${getDuration(entry.duration)}"
                                                    : ""),
                                              ],
                                            ),
                                            Center(
                                                child: Text(entry.time ?? "")),
                                          ],
                                        ),
                                      );
                                    }),
                              ),
                            ],
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            itemCount: missedLogs.length,
                            padding: const EdgeInsets.all(PADDING_SM),
                            itemBuilder: (context, index) {
                              var entry = missedLogs[index];
                              return ListTile(
                                leading: SvgPicture.asset(
                                  "assets/images/profile_icon.svg",
                                  width: SIZE_LG + 4,
                                  height: SIZE_LG + 4,
                                ),
                                title: Text(
                                  entry.cntName ?? entry.cntNumber ?? 'Unknown',
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: entry.cntStatus == 'M'
                                          ? DARK_ERROR_COLOR
                                          : NORMAL_TEXT_CLR),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Text('${entry.cntStatus}')
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          getCallStatusImg(entry.cntStatus),
                                        ),
                                        const Text('Phone'),
                                        const SizedBox(
                                            width:
                                                5), // Adjust the spacing between the text and the image
                                        Text(entry.cntStatus != 'M'
                                            ? "• ${getDuration(entry.duration)}"
                                            : ""),
                                      ],
                                    ),
                                    Center(child: Text(entry.time ?? "")),
                                  ],
                                ),
                              );
                            })
            : const Center(
                child: Text("Available for Android users only!"),
              ));
  }
}
