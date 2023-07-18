import 'dart:convert';
import 'dart:io';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_app/backend/api_manager.dart';
import 'package:flutter_app/components/story_widget.dart';
import 'package:flutter_app/constants/constants.dart';
import 'package:flutter_app/constants/utility.dart';
import 'package:flutter_app/modal/feed_data_model.dart';
import 'package:flutter_app/screens/login_screen.dart';
import 'package:flutter_app/screens/splash_screen.dart';
import 'package:flutter_app/widgets/card.dart';
import 'package:flutter_app/widgets/storyview.dart';
import 'package:flutter_app/screens/detail_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<Items> feedData = [];
  List<Items> storySeenData = [];
  List<Items> storyNotSeenData = [];
  List<Items> storyData = [];
  String paginationFeedUrl = "";
  String paginationStoryUrl = "";
  bool hasMoreData = true;
  bool hasMoreStoryData = true;
  bool isLoading = false;
  bool isStoryLoading = false;
  bool disableBtn = false;
  bool isPaginationLoading = false;
  String superCustomerID = "", compCode = "", accountId = "", roleId = "";
  var responseDataFeed, responseStorySeen, responseStoryNotSeen;

  PageController _pageController = PageController();

  Future<Null> getData() async {
    superCustomerID = await ApiManager(context).getLocalData("super_cust_id");
    compCode = await ApiManager(context).getLocalData("comp_code");
    accountId = await ApiManager(context).getLocalData("account_id");
    roleId = await ApiManager(context).getLocalData("role_id");

    if (!hasMoreData) return;
    if (!hasMoreStoryData) return;

    if (paginationFeedUrl == "") {
      responseDataFeed = await ApiManager(context).getApiData(
          "$BASE_URL/feed?super_cust_id=$superCustomerID&comp_code=$compCode&acc_id=$accountId&role=$roleId");
    } else if (hasMoreData) {
      responseDataFeed =
          await ApiManager(context).getApiData(paginationFeedUrl);
    }

    if (paginationStoryUrl == "") {
      responseStoryNotSeen = await ApiManager(context).getApiData(
          "$BASE_URL/not_seen_story?super_cust_id=$superCustomerID&comp_code=$compCode&acc_id=$accountId&role=$roleId");
    } else if (hasMoreStoryData) {
      responseStoryNotSeen =
          await ApiManager(context).getApiData(paginationStoryUrl);
    }

    if (responseDataFeed != null) {
      setState(() {
        for (var i in responseDataFeed["items"]) {
          feedData.add(Items.fromJson(i));
        }
        if (responseDataFeed["hasMore"]) {
          hasMoreData = true;
          for (var i in responseDataFeed["links"]) {
            if (i["rel"] == "next") {
              paginationFeedUrl = i["href"];
            }
          }
        } else {
          hasMoreData = false;
        }
        isLoading = false;
        isPaginationLoading = false;
      });
    }

    if (responseStoryNotSeen != null) {
      setState(() {
        for (var i in responseStoryNotSeen["items"]) {
          storyNotSeenData.add(Items.fromJson(i));
        }
        if (responseStoryNotSeen["hasMore"]) {
          hasMoreStoryData = true;
          for (var i in responseStoryNotSeen["links"]) {
            if (i["rel"] == "next") {
              paginationStoryUrl = i["href"];
            }
          }
        } else {
          hasMoreStoryData = false;
        }
        isStoryLoading = false;
        isPaginationLoading = false;
      });
    }
    setState(() {
      disableBtn = false;
    });
  }

  Future<Null> getSeenStory() async {
    responseStorySeen = await ApiManager(context).getApiData(
        "$BASE_URL/story_seen?super_cust_id=$superCustomerID&comp_code=$compCode&acc_id=$accountId&role=$roleId");
    setState(() {
      storySeenData.clear();
      for (var i in responseStorySeen["items"]) {
        storySeenData.add(Items.fromJson(i));
      }
      storyData.clear();
      storyData = [...storyNotSeenData, ...storySeenData];
    });
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  @override
  void initState() {
    super.initState();
    print("ascascascascascasc");
    setState(() {
      isLoading = true;
      isStoryLoading = true;
      disableBtn = true;
    });

    getData().then((value) => getSeenStory());

    _pageController.addListener(() {
      if (_pageController.position.atEdge) {
        bool isTop = _pageController.position.pixels == 0;
        print(_pageController.position.pixels);
        if (!isTop) {
          setState(() {
            isPaginationLoading = true;
            getData();
          });
        }
      }
    });
  }

  String getBgImage(condition) {
    if (condition == 'LEAD') {
      return 'assets/images/icon.png';
    } else {
      return 'assets/images/mail_icon.png';
    }
  }

  String getMiddleImage(condition, status) {
    if (condition == 'LEAD') {
      if (status == "Contact Updated") {
        return 'assets/images/update_lead_card_ic.svg';
      } else {
        return 'assets/images/create_lead_card_ic.svg';
      }
    } else if (condition == 'EMAIL_STATUS') {
      return 'assets/images/email_card_ic.svg';
    } else {
      return 'assets/images/opp_card_ic.svg';
    }
  }

  setStoryToSeen(id, source) async {
    if (accountId != null) {
      final responcePost;
      var seenJsonData;
      storyData.clear();
      storyNotSeenData.forEach(
        (element) => {
          if (element.id == id)
            {element.hasSeenStory = "Y", seenJsonData = element}
        },
      );
      storyNotSeenData.removeWhere((element) => element.id == id);
      storySeenData.add(seenJsonData);

      setState(() {
        storyData = [...storyNotSeenData, ...storySeenData];
      });
      responcePost = await ApiManager(context).postApiData(
          "$BASE_URL/story_seen?account_id=$accountId&story_feed_id=$id&super_customer_id=$superCustomerID&comp_code=$compCode&source=$source");
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  doRefresh() {
    setState(() {
      isLoading = true;
      isStoryLoading = true;
      disableBtn = true;
    });
    hasMoreStoryData = true;
    hasMoreData = true;
    feedData.clear();
    storyData.clear();
    storyNotSeenData.clear();
    storySeenData.clear();
    paginationStoryUrl = "";
    paginationFeedUrl = "";
    getData().then((value) => getSeenStory());
  }

  @override
  Widget build(BuildContext context) {
    const title = "My Feeds";
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          title,
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh,
              color: Colors.black,
            ),
            onPressed: disableBtn ? null : () => doRefresh(),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          SizedBox(
            height: 84,
            child: isStoryLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: DASH_COLOR,
                    ),
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: PADDING_MD),
                    itemCount: storyData.length,
                    itemBuilder: (BuildContext context, int index) {
                      final nDataList = storyData[index];
                      return GestureDetector(
                        onTap: () {
                          if (nDataList.hasSeenStory != "Y") {
                            setStoryToSeen(nDataList.id, nDataList.via);
                          }
                          showDialog(
                            context: context,
                            builder: (ctx) => StoryPageView(
                              contactName: nDataList.contactName.toString(),
                              activityStatus:
                                  nDataList.activityStatus.toString(),
                              bgImage: getBgImage(nDataList.via),
                              padding: const EdgeInsets.all(16.0),
                              source: nDataList.via,
                              middleImage: getMiddleImage(
                                  nDataList.via, nDataList.activityStatus),
                              bodyText: nDataList.description.toString(),
                              dateAdded: nDataList.dateAdded.toString(),
                              mobileNum: nDataList.mobile,
                              emailAddress: nDataList.email,
                              id: nDataList.id ?? "",
                            ),
                          );
                        },
                        child: StoryWidget(
                          isActive: nDataList.hasSeenStory != 'Y',
                          name: nDataList.contactName?.split(" ")[0] ?? "",
                        ),
                      );
                    },
                  ),
          ),
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: DASH_COLOR,
                    ),
                  )
                : PageView.builder(
                    controller: _pageController,
                    itemCount: feedData.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      final nDataList = feedData[index];
                      return Padding(
                        padding:
                            const EdgeInsets.symmetric(vertical: PADDING_SM),
                        child: FeedCards(
                          contactName: nDataList.contactName ?? "",
                          activityStatus: nDataList.activityStatus ?? "",
                          bgImage: getBgImage(nDataList.via),
                          padding: const EdgeInsets.all(16.0),
                          source: nDataList.via,
                          middleImage: getMiddleImage(
                              nDataList.via, nDataList.activityStatus),
                          bodyText: nDataList.description ?? "",
                          dateAdded: nDataList.dateAdded ?? "",
                          mobileNum: nDataList.mobile,
                          emailAddress: nDataList.email,
                          id: nDataList.id ?? "",
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
