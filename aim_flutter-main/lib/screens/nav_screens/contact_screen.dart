import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_app/backend/api_manager.dart';
import 'package:flutter_app/constants/constants.dart';
import 'package:flutter_app/modal/contact_model.dart';
import 'package:flutter_app/modal/contact_owner_model.dart';
import 'package:flutter_app/screens/detail_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_app/screens/nav_screens/contact/contact_filter.dart';
import 'package:flutter_app/screens/nav_screens/contact/new_contact.dart';
import 'package:flutter_app/screens/nav_screens/contact/recent_call.dart';

import 'package:flutter_app/screens/call_summary.dart';

class ContactScreen extends StatefulWidget {
  final toSelectOwner;
  const ContactScreen({super.key, this.toSelectOwner});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<ContactItems> contactData = [];
  List<ContactItems> searchContactData = [];
  List<ContactOwnerItems> ownerData = [];
  String? dropdownValue = 'All Contacts';
  double appBarHeight = AppBar().preferredSize.height;
  String superCustomerID = "",
      compCode = "",
      accountId = "",
      roleId = "",
      paginationUrl = "",
      selectedFilter = "ALLCNT",
      paginationSearchUrl = "";
  bool isLoading = true,
      hasMoreData = true,
      isPaginationLoading = false,
      showSearchData = false,
      hasSearchMoreData = true;
  var responseData, searchResData, responseDataOwner;
  bool _isDialogOpen = false;

  void getAllContacts() async {
    if (!hasMoreData) return;
    if (paginationUrl == "") {
      responseData = await ApiManager(context).getApiData(
          "$BASE_URL/contacts?super_cust_id=$superCustomerID&comp_code=$compCode&acc_id=$accountId&filter_val=$selectedFilter");
    } else if (hasMoreData) {
      responseData = await ApiManager(context).getApiData(paginationUrl);
    }

    if (responseData != null) {
      setState(() {
        for (var i in responseData["items"]) {
          contactData.add(ContactItems.fromJson(i));
        }
        if (responseData["hasMore"]) {
          hasMoreData = true;
          for (var i in responseData["links"]) {
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

  void getAllOwner() async {
    setState(() {
      isLoading = true;
    });
    responseDataOwner = await ApiManager(context).getApiData(
        "$BASE_URL/user-accounts?super_cust_id=$superCustomerID&comp_code=$compCode&acc_id=$accountId&role_id=$roleId");
    if (responseDataOwner != null) {
      setState(() {
        for (var i in responseDataOwner["items"]) {
          ownerData.add(ContactOwnerItems.fromJson(i));
        }
        isLoading = false;
      });
    }
  }

  void getSearchContacts(String searchVal) async {
    if (!hasSearchMoreData) return;
    if (paginationSearchUrl == "") {
      searchResData = await ApiManager(context).getApiData(
          "$BASE_URL/contacts?super_cust_id=$superCustomerID&comp_code=$compCode&filter_val=$selectedFilter&search=$searchVal&acc_id=$accountId");
    } else if (hasMoreData) {
      searchResData = await ApiManager(context).getApiData(paginationSearchUrl);
    }
    if (searchResData != null) {
      setState(() {
        for (var i in searchResData["items"]) {
          searchContactData.add(ContactItems.fromJson(i));
        }
        if (searchResData["hasMore"]) {
          hasSearchMoreData = true;
          for (var i in searchResData["links"]) {
            if (i["rel"] == "next") {
              paginationSearchUrl = i["href"];
            }
          }
        } else {
          hasSearchMoreData = false;
          paginationSearchUrl = "";
        }
        isLoading = false;
        isPaginationLoading = false;
      });
    }
  }

  Future<void> _selectFiltersFrmScreen(BuildContext context) async {
    final filter = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ContactFilter(
                filter: selectedFilter,
              )),
    );
    setState(() {
      showSearchData = false;
      searchController.clear();
      contactData.clear();
      isLoading = true;
      selectedFilter = filter ?? "ALLCNT";
      paginationUrl = "";
      paginationSearchUrl = "";
      hasMoreData = true;
      hasSearchMoreData = true;
    });
    // }
    getAllContacts();

    if (!mounted) return;
  }

  Future<void> getIds() async {
    superCustomerID = await ApiManager(context).getLocalData("super_cust_id");
    compCode = await ApiManager(context).getLocalData("comp_code");
    accountId = await ApiManager(context).getLocalData("account_id");
    roleId = await ApiManager(context).getLocalData("role_id");
  }

  @override
  void initState() {
    super.initState();
    getIds().then((value) => {getAllContacts(), getAllOwner()});

    // getAllContacts();
    // getAllOwner();
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        bool isTop = _scrollController.position.pixels == 0;
        if (!isTop) {
          setState(() {
            if (showSearchData &&
                (paginationSearchUrl != "" || paginationSearchUrl != null)) {
              isPaginationLoading = true;

              getSearchContacts(searchController.text);
            } else if (!showSearchData &&
                (paginationUrl != "" || paginationUrl != null)) {
              isPaginationLoading = true;
              getAllContacts();
            }
          });
        }
      }
    });
  }

  @override
  void _showBottomSheet(BuildContext context) {
    FocusScope.of(context).unfocus();
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
                    blurRadius: 25.0,
                    spreadRadius: -5.0,
                    offset: const Offset(
                      -3.0,
                      5.0,
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RecentCall()),
                      );
                      //print('Recents Call');
                    },
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
                    },
                    trailing:
                        SvgPicture.asset("assets/images/tick_contact_ic.svg"),
                  ),
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
    ;
  }

  String getSelectedFilterText(filter) {
    if (filter == "MYCNT") return "My Contacts";
    if (filter == "LWCNT") return "New Last Week";
    if (filter == "TWCNT") return "New This Week";
    if (filter == "RMCNT") return "Recently Modified";
    return "All Contacts";
  }

  @override
  void dispose() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.dispose();
  }

  Future<void> _createNewCnt(BuildContext context) async {
    final data = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => NewContact(
                id: null,
              )),
    );
    print(data);
    if (data == 'Y') {
      setState(() {
        showSearchData = false;
        searchController.clear();
        contactData.clear();
        isLoading = true;
        selectedFilter = "ALLCNT";
        paginationUrl = "";
        paginationSearchUrl = "";
        hasMoreData = true;
        hasSearchMoreData = true;
      });
      // }
      getAllContacts();
    }

    if (!mounted) return;
  }

  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double bottomChinHeight = MediaQuery.of(context).padding.bottom;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          leading: widget.toSelectOwner == null
              ? IconButton(
                  icon: SvgPicture.asset(
                    "assets/images/filter_icon.svg",
                  ),
                  onPressed: () {
                    _selectFiltersFrmScreen(context);
                    // print('Filter icon');
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => const ContactFilter()),
                    // );
                  },
                )
              : GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Center(
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: NORMAL_TEXT_CLR),
                    ),
                  )),
          title: TextButton(
            onPressed: () {
              widget.toSelectOwner == null ? _showBottomSheet(context) : null;
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    widget.toSelectOwner == 'Y'
                        ? 'Contact Owners'
                        : 'All Contact',
                    style: const TextStyle(
                        fontSize: FONT_APPBAR_TITLE, color: APPBAR_TXT_CLR)),
                SizedBox(
                  width: 8,
                ),
                widget.toSelectOwner == null
                    ? _isDialogOpen
                        ? SvgPicture.asset(
                            "assets/images/arrow_up_header_ic.svg")
                        : SvgPicture.asset(
                            "assets/images/arrow_down_header_ic.svg")
                    : const SizedBox(),
              ],
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                if (widget.toSelectOwner == null) {
                  _createNewCnt(context);
                }
              },
              icon: SvgPicture.asset(
                "assets/images/add_icon.svg",
                color: widget.toSelectOwner != null
                    ? Colors.white
                    : const Color(0xFF5665C0),
              ),
            )
          ],
          bottom: widget.toSelectOwner == 'Y'
              ? const PreferredSize(
                  preferredSize: Size.fromHeight(0),
                  child: SizedBox(),
                )
              : PreferredSize(
                  preferredSize: const Size.fromHeight(PADDING_XL),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: BG_COLOR,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: CupertinoSearchTextField(
                          controller: searchController,
                          placeholder: "Search Contacts",
                          onChanged: (value) {
                            if (value == "") {
                              searchContactData.clear();
                              setState(() {
                                isLoading = false;
                                showSearchData = false;
                              });
                            }
                          },
                          onSubmitted: (value) {
                            setState(() {
                              isLoading = true;
                              showSearchData = true;
                              paginationSearchUrl = "";
                              hasSearchMoreData = true;
                            });
                            searchContactData.clear();
                            getSearchContacts(value);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
        ),
        body: Column(
          children: [
            selectedFilter != "ALLCNT" && selectedFilter != ""
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                    color: FILTER_BG,
                    child: Text(
                      getSelectedFilterText(selectedFilter),
                      style: const TextStyle(
                          fontSize: FONT_XSS, color: APPBAR_TXT_CLR),
                    ))
                : const SizedBox(),
            Expanded(
              // height: MediaQuery.of(context).size.height -
              //     PADDING_XL -
              //     appBarHeight -
              //     (widget.toSelectOwner == null ? BOTTOM_NAV_HEIGHT : 0) -
              //     statusBarHeight -
              //     (selectedFilter != "ALLCNT" && selectedFilter != ""
              //         ? Platform.isIOS
              //             ? 48
              //             : 20
              //         : Platform.isIOS
              //             ? 22
              //             : 0),
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: DASH_COLOR,
                      ),
                    )
                  : widget.toSelectOwner == 'Y'
                      ? SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(PADDING_MD),
                              itemCount: ownerData.length,
                              itemBuilder: (BuildContext context, int index) {
                                final nDataList = ownerData[index];
                                return Column(
                                  children: [
                                    const SizedBox(
                                      height: SIZE_XS,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(
                                          context,
                                          "${nDataList.accountId ?? ""} ${nDataList.name ?? ""}",
                                        );
                                      },
                                      child: Container(
                                        // color: Colors.transparent,
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              "assets/images/bottom_nav_ic/contact_profile.svg",
                                            ),
                                            const SizedBox(
                                              width: SIZE_MD,
                                            ),
                                            Expanded(
                                              child: Container(
                                                color: Colors.transparent,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      nDataList.name ??
                                                          NOT_PROVIDED,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headlineMedium,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: SIZE_XS,
                                    ),
                                    const Divider(
                                      thickness: 1,
                                    ),
                                  ],
                                );
                              }),
                        )
                      : showSearchData
                          ? searchContactData.isEmpty
                              ? const Center(
                                  child: Text("No record found!"),
                                )
                              : SingleChildScrollView(
                                  controller: _scrollController,
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    children: [
                                      ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        padding:
                                            const EdgeInsets.all(PADDING_MD),
                                        itemCount: searchContactData.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final nDataList =
                                              searchContactData[index];
                                          return Column(
                                            children: [
                                              const SizedBox(
                                                height: SIZE_XS,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  if (widget.toSelectOwner ==
                                                      null) {
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .push(
                                                      MaterialPageRoute(
                                                        builder: (_) => DetailScreen(
                                                            id: nDataList
                                                                    .leadId ??
                                                                "",
                                                            source: "LEAD",
                                                            name: nDataList
                                                                    .fullName ??
                                                                ""),
                                                      ),
                                                    );
                                                  } else {
                                                    Navigator.pop(
                                                      context,
                                                      "${nDataList.leadId ?? ""} ${nDataList.fullName ?? ""}",
                                                    );
                                                  }
                                                },
                                                child: Container(
                                                  color: Colors.transparent,
                                                  child: Row(
                                                    children: [
                                                      SvgPicture.asset(
                                                        "assets/images/bottom_nav_ic/contact_profile.svg",
                                                      ),
                                                      const SizedBox(
                                                        width: SIZE_MD,
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              nDataList
                                                                      .fullName ??
                                                                  NOT_PROVIDED,
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headlineMedium,
                                                            ),
                                                            Text(
                                                              nDataList
                                                                      .company ??
                                                                  NOT_PROVIDED,
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: nDataList
                                                                          .company !=
                                                                      null
                                                                  ? Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyMedium
                                                                  : TextStyles
                                                                      .notProvidedtextStyle,
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: SIZE_XS,
                                              ),
                                              const Divider(
                                                thickness: 1,
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                      isPaginationLoading
                                          ? const Center(
                                              child: CircularProgressIndicator(
                                                color: DASH_COLOR,
                                              ),
                                            )
                                          : const SizedBox()
                                    ],
                                  ),
                                )
                          : contactData.isEmpty
                              ? Center(
                                  child: Text("No record found!"),
                                )
                              : SingleChildScrollView(
                                  controller: _scrollController,
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    children: [
                                      ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        padding:
                                            const EdgeInsets.all(PADDING_MD),
                                        itemCount: contactData.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final nDataList = contactData[index];
                                          return Column(
                                            children: [
                                              const SizedBox(
                                                height: SIZE_XS,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  if (widget.toSelectOwner ==
                                                      null) {
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .push(
                                                      MaterialPageRoute(
                                                        builder: (_) => DetailScreen(
                                                            id: nDataList
                                                                    .leadId ??
                                                                "",
                                                            source: "LEAD",
                                                            name: nDataList
                                                                    .fullName ??
                                                                ""),
                                                      ),
                                                    );
                                                  } else {
                                                    Navigator.pop(
                                                      context,
                                                      "${nDataList.leadId ?? ""} ${nDataList.fullName ?? ""}",
                                                    );
                                                  }
                                                },
                                                child: Container(
                                                  color: Colors.transparent,
                                                  child: Row(
                                                    children: [
                                                      SvgPicture.asset(
                                                        "assets/images/bottom_nav_ic/contact_profile.svg",
                                                      ),
                                                      const SizedBox(
                                                        width: SIZE_MD,
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              nDataList
                                                                      .fullName ??
                                                                  NOT_PROVIDED,
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headlineMedium,
                                                            ),
                                                            Text(
                                                              nDataList
                                                                      .company ??
                                                                  NOT_PROVIDED,
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: nDataList
                                                                          .company !=
                                                                      null
                                                                  ? Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyMedium
                                                                  : TextStyles
                                                                      .notProvidedtextStyle,
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: SIZE_XS,
                                              ),
                                              const Divider(
                                                thickness: 1,
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                      isPaginationLoading
                                          ? const Center(
                                              child: CircularProgressIndicator(
                                                color: DASH_COLOR,
                                              ),
                                            )
                                          : const SizedBox()
                                    ],
                                  ),
                                ),
            ),
          ],
        ));
  }
}
