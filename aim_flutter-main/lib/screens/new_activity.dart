import 'dart:convert';

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/backend/api_manager.dart';
import 'package:flutter_app/modal/action_type_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_app/constants/constants.dart';
import 'package:get/route_manager.dart';
import 'package:get/utils.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app/screens/nav_screens/contact_screen.dart';

class NewActivity extends StatefulWidget {
  String? cntName, cntId, leadOwnerId, leadOwnerName, selectedAction;
  NewActivity(
      {super.key,
      this.cntId,
      this.cntName,
      this.leadOwnerId,
      this.leadOwnerName,
      this.selectedAction});

  @override
  State<NewActivity> createState() => _NewActivityState();
}

class _NewActivityState extends State<NewActivity> {
  String dateText =
      DateFormat('MMM dd, yyyy').format(DateTime.now()).toString();
  String timeText = DateFormat('HH:mm').format(DateTime.now()).toString();

  final _activityName = TextEditingController();
  final _activityDesc = TextEditingController();
  final _activityLink = TextEditingController();

  bool sendCalInvSelf = false;
  bool sendCalInvClient = false;
  String? selectedActivityType;
  String? selectedUsername, selectedUserId;
  String? selectedOwnername, selectedOwnerId;
  String? currntUserName;
  String superCustomerID = "", compCode = "", accountId = "", roleId = "";
  var responseData;
  bool isLoading = false;
  bool hasErrorCntName = false;
  List<ActionTypeItems> actionTypes = [];
  bool isClientSelEnabled = false;

  Future<void> _selectOwner(BuildContext context) async {
    final data = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const ContactScreen(toSelectOwner: 'Y')),
    );
    if (data != null) {
      int idx = data.indexOf(" ");
      List parts = [
        data.substring(0, idx).trim(),
        data.substring(idx + 1).trim()
      ];

      setState(() {
        selectedOwnerId = parts[0];
        selectedOwnername = parts[1];
      });
    }

    if (!mounted) return;
  }

  Future<void> _selectContact(BuildContext context) async {
    final data = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const ContactScreen(toSelectOwner: 'N')),
    );
    if (data != null) {
      int idx = data.indexOf(" ");
      List parts = [
        data.substring(0, idx).trim(),
        data.substring(idx + 1).trim()
      ];

      setState(() {
        selectedUserId = parts[0];
        selectedUsername = parts[1];
        hasErrorCntName = false;
      });
    }

    if (!mounted) return;
  }

  // void getCurrUserInfo() async {
  //   final userName = await ApiManager(context).getLocalData("full_name");
  //   setState(() {
  //     currntUserName = userName;
  //   });
  // }

  void checkValidation() {
    setState(() {
      hasErrorCntName = false;
    });
    if (selectedUserId == null || selectedUserId == "") {
      Get.snackbar(
        "Provide Contact Name",
        "Contact name should not be empty.",
        colorText: DARK_ERROR_COLOR,
        backgroundColor: LIGHT_ERROR_COLOR,
        icon: const Icon(
          Icons.error,
          color: DARK_ERROR_COLOR,
        ),
      );
      setState(() {
        hasErrorCntName = true;
      });
    } else {
      addActivity();
    }
  }

  void addActivity() async {
    setState(() {
      isLoading = true;
    });
    superCustomerID = await ApiManager(context).getLocalData("super_cust_id");
    compCode = await ApiManager(context).getLocalData("comp_code");
    accountId = await ApiManager(context).getLocalData("account_id");
    roleId = await ApiManager(context).getLocalData("role_id");
    final dateTime = dateText + ' ' + timeText;

    responseData = await ApiManager(context).postApiData(
        "$BASE_URL/activity?acc_id=$accountId&lead_id=$selectedUserId&super_cust_id=$superCustomerID&comp_code=$compCode&p_time=$timeText&ev_date_time=$dateTime&ev_date=$dateText&task_name=${_activityName.text}&action_type_id=$selectedActivityType&owner_id=$selectedOwnerId&p_desc=${_activityDesc.text}&p_link=${_activityLink.text}&invite_client=${sendCalInvClient ? "Y" : null}&invite_self=${sendCalInvSelf ? "Y" : null}");
    if (responseData.statusCode == 200) {
      final data = jsonDecode(responseData.body);
      Get.snackbar(
        "Activity Added",
        data['response'],
        colorText: DARK_SUCCESS_COLOR,
        backgroundColor: LIGHT_SUCCESS_COLOR,
        icon: const Icon(
          Icons.check,
          color: DARK_SUCCESS_COLOR,
        ),
      );
      setState(() {
        isLoading = false;
      });
      if (widget.selectedAction == 'Call') {
        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        Navigator.pop(context, 'Y');
      }
    } else {
      setState(() {
        isLoading = false;
      });
      Get.snackbar(
        "An Error Occured",
        "Something went wrong! Please try again later/",
        colorText: DARK_ERROR_COLOR,
        backgroundColor: LIGHT_ERROR_COLOR,
        icon: const Icon(
          Icons.error,
          color: DARK_ERROR_COLOR,
        ),
      );
    }

    // if (selectedActivityType == 'Mail' && data['error_mssage']) {
    // Get.snackbar(
    //   "An Error Occured",
    //   data['error_mssage'],
    //   colorText: DARK_ERROR_COLOR,
    //   backgroundColor: LIGHT_ERROR_COLOR,
    //   icon: const Icon(
    //     Icons.error,
    //     color: DARK_ERROR_COLOR,
    //   ),
    // );
    // }
  }

  void getAllActType() async {
    setState(() {
      isLoading = true;
    });
    final resTypes;
    superCustomerID = await ApiManager(context).getLocalData("super_cust_id");
    resTypes = await ApiManager(context)
        .getApiData("$BASE_URL/activity?super_cust_id=$superCustomerID");
    if (resTypes != null) {
      setState(() {
        for (var i in resTypes["items"]) {
          actionTypes.add(ActionTypeItems.fromJson(i));
        }
        if (widget.selectedAction == 'Call') {
          selectedActivityType = 'Call';
        } else {
          selectedActivityType = actionTypes[0].disp;
        }
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getCurrUserInfo();
    getAllActType();
    if (widget.cntId != "" || widget.cntId != null) {
      setState(() {
        selectedUserId = widget.cntId;
        selectedUsername = widget.cntName;
      });
    }
    if (widget.leadOwnerId != "" || widget.leadOwnerId != null) {
      setState(() {
        selectedOwnerId = widget.leadOwnerId;
        selectedOwnername = widget.leadOwnerName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Center(
                child: Text(
                  'Cancel',
                  style: TextStyle(fontSize: FONT_SM, color: NORMAL_TEXT_CLR),
                ),
              ),
            ),
            title: const Text(
              'New Activity',
              style: TextStyle(fontSize: FONT_SM + 2, color: NORMAL_TEXT_CLR),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  checkValidation();
                },
                child: const Text(
                  'Done',
                  style: TextStyle(fontSize: FONT_SM, color: NORMAL_TEXT_CLR),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(PADDING_MD),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Activity Name',
                    style: TextStyle(fontSize: FONT_XSS, color: SECONDARY_CLR),
                  ),
                  TextField(
                    controller: _activityName,
                    decoration: const InputDecoration(
                      hintText: 'New Activity',
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: INPUT_BORDER_CLR, width: 1.0),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: INPUT_BORDER_CLR, width: 1.0),
                      ), // Add your hint word here
                    ),
                  ),
                  const SizedBox(
                    height: PADDING_XS,
                  ),
                  const Text(
                    'Activity Type',
                    style: TextStyle(fontSize: FONT_XSS, color: SECONDARY_CLR),
                  ),
                  const SizedBox(
                    height: PADDING_XS,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButton<String>(
                          value: selectedActivityType,
                          onChanged: (String? newValue) {
                            setState(() {
                              sendCalInvSelf = false;
                            });
                            setState(() {
                              selectedActivityType = newValue;
                              sendCalInvClient = false;
                              isClientSelEnabled = false;
                              sendCalInvSelf = false;
                            });
                          },
                          items: actionTypes.asMap().entries.map((entry) {
                            final String displayValue = entry.value.disp ?? "";
                            // final String actualValue =
                            //     entry.value.ret.toString();

                            return DropdownMenuItem<String>(
                              value: displayValue,
                              child: Text(displayValue),
                            );
                          }).toList(),
                          isExpanded: true,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: PADDING_XS,
                  ),
                  const Text(
                    'Date / Time',
                    style: TextStyle(fontSize: FONT_XSS, color: SECONDARY_CLR),
                  ),
                  const SizedBox(
                    height: PADDING_XS,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: InkWell(
                        onTap: () async {
                          showDatePicker(
                            context: context,
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: Colors.blue,
                                    onPrimary: Colors.white,
                                    onSurface: Colors.black,
                                  ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      primary: Colors.white,
                                      backgroundColor: Colors.blue,
                                      textStyle: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                            helpText: 'Select Date',
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(Duration(days: 14)),
                          ).then((pickedDate) {
                            if (pickedDate == null) {
                              return;
                            }
                            setState(() {
                              dateText =
                                  DateFormat('MMM dd, yyyy').format(pickedDate);
                            });
                          });
                        },
                        child: Text(
                          dateText,
                          style: const TextStyle(
                              fontSize: FONT_SM, color: NORMAL_TEXT_CLR),
                        ),
                      )),
                      InkWell(
                        onTap: () async {
                          final TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: Colors.blue,
                                    onPrimary: Colors.white,
                                    onSurface: Colors.black,
                                  ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      primary: Colors.white,
                                      backgroundColor: Colors.blue,
                                      textStyle: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                            initialTime: const TimeOfDay(hour: 7, minute: 15),
                          );

                          setState(() {
                            if (pickedTime == null) {
                              timeText = DateFormat('HH:mm')
                                  .format(DateTime.now())
                                  .toString();
                            } else {
                              timeText =
                                  '${pickedTime.hour}:${pickedTime.minute}'
                                      .padLeft(5, '0');
                            }
                          });
                        },
                        child: Text(
                          timeText,
                          style: const TextStyle(
                              fontSize: FONT_SM, color: NORMAL_TEXT_CLR),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: SIZE_XS,
                  ),
                  // InkWell(
                  //   onTap: () {
                  //     // DateTime startDate = new DateFormat("dd MMM, yyyy HH:mm")
                  //     //     .parse("$dateText $timeText");
                  //     // List<String>? sentTo = [];
                  //     // sentTo.add("mukesh.suthar@abacasys.com");
                  //     // Add2Calendar.addEvent2Cal(
                  //     //   buildEvent(startDate, sentTo),
                  //     // );
                  //   },
                  //   child: const Text(
                  //     'Save In Calendar',
                  //     style: TextStyle(fontSize: FONT_SM, color: Color(0xFF0C7DD9)),
                  //   ),
                  // ),
                  const Divider(
                    thickness: 1,
                  ),
                  const SizedBox(
                    height: SIZE_SM,
                  ),
                  Text(
                    'Contact Name',
                    style: TextStyle(
                        fontSize: FONT_XSS,
                        color:
                            hasErrorCntName ? DARK_HINT_COLOR : SECONDARY_CLR),
                  ),
                  const SizedBox(
                    height: SIZE_XS,
                  ),
                  GestureDetector(
                    onTap: () {
                      _selectContact(context);
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            selectedUsername ?? "Select Contact Name",
                            style: TextStyle(
                                fontSize: FONT_SM,
                                color: selectedUsername == null
                                    ? hasErrorCntName
                                        ? DARK_HINT_COLOR
                                        : SECONDARY_CLR
                                    : NORMAL_TEXT_CLR),
                          ),
                        ),
                        // selectedUserId == null
                        // ?
                        const Icon(Icons.keyboard_arrow_right)
                        // : GestureDetector(
                        //     onTap: () {
                        //       setState(() {
                        //         selectedUserId = null;
                        //         selectedUsername = null;
                        //       });
                        //     },
                        //     child: const Icon(Icons.cancel)),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 1,
                    color: hasErrorCntName ? DARK_HINT_COLOR : BORDER_COLOR,
                  ),
                  SizedBox(
                    height: PADDING_XS,
                  ),
                  Text(
                    'Action For',
                    style: TextStyle(fontSize: FONT_XSS, color: SECONDARY_CLR),
                  ),
                  SizedBox(
                    height: PADDING_XS,
                  ),
                  GestureDetector(
                    onTap: () {
                      _selectOwner(context);
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            selectedOwnername ?? "Select Action Owner",
                            style: TextStyle(
                                fontSize: FONT_SM,
                                color: selectedOwnername == null
                                    ? SECONDARY_CLR
                                    : NORMAL_TEXT_CLR),
                          ),
                        ),
                        // selectedOwnerId == null
                        // ?
                        const Icon(Icons.keyboard_arrow_right)
                        // : GestureDetector(
                        //     onTap: () {
                        //       setState(() {
                        //         selectedOwnerId = null;
                        //         selectedOwnername = null;
                        //       });
                        //     },
                        //     child: const Icon(Icons.cancel)),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 1,
                  ),
                  SizedBox(
                    height: PADDING_XS,
                  ),
                  Text(
                    'Description',
                    style: TextStyle(fontSize: FONT_XSS, color: SECONDARY_CLR),
                  ),
                  SizedBox(
                    height: PADDING_XS,
                  ),
                  TextField(
                    controller: _activityDesc,
                    decoration: const InputDecoration(
                      hintText: 'Add Description',
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: INPUT_BORDER_CLR, width: 1.0),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: INPUT_BORDER_CLR, width: 1.0),
                      ), // Add your hint word here
                    ),
                  ),
                  // Divider(
                  //   thickness: 1,
                  // ),
                  SizedBox(
                    height: PADDING_XS,
                  ),
                  Text(
                    'Link',
                    style: TextStyle(fontSize: FONT_XSS, color: SECONDARY_CLR),
                  ),
                  SizedBox(
                    height: PADDING_XS,
                  ),
                  TextField(
                    controller: _activityLink,
                    decoration: const InputDecoration(
                      hintText: 'Add Link',
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: INPUT_BORDER_CLR, width: 1.0),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: INPUT_BORDER_CLR, width: 1.0),
                      ), // Add your hint word here
                    ),
                  ),
                  const SizedBox(
                    height: PADDING_XS,
                  ),
                  const Text('Send Calendar Invite',
                      style: TextStyle(
                          fontSize: FONT_XSS, color: NORMAL_TEXT_CLR)),
                  const SizedBox(
                    height: PADDING_XS,
                  ),

                  CheckboxListTile(
                    title: Text(
                      'To The Assignee (${selectedOwnername ?? 'Unassigned'})',
                      style:
                          TextStyle(fontSize: FONT_XSS, color: NORMAL_TEXT_CLR),
                    ),
                    value: sendCalInvSelf,
                    onChanged: (bool? value) {
                      setState(() {
                        sendCalInvSelf = value ?? false;
                        if (sendCalInvSelf &&
                            (selectedActivityType == 'Visit' ||
                                selectedActivityType == 'Call')) {
                          isClientSelEnabled = true;
                        } else {
                          sendCalInvClient = false;
                          isClientSelEnabled = false;
                        }
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    checkColor: Colors.white,
                    activeColor:
                        Colors.green, // Customize the color of the checkmark
                    contentPadding: EdgeInsets.zero,
                  ),
                  // SizedBox(
                  //   height: PADDING_XS,
                  // ),
                  // CheckboxListTile(
                  //   title: Text(
                  //     'To The Client (Atul)',
                  //     style: TextStyle(fontSize: FONT_XSS, color: NORMAL_TEXT_CLR),
                  //   ),
                  //   value: isChecked,
                  //   onChanged: null, // Set onChanged to null to disable the checkbox
                  //   controlAffinity: ListTileControlAffinity.leading,
                  //   checkColor: Colors.white,
                  //   activeColor: Colors.white, // Customize the color of the checkmark
                  // ),
                  CheckboxListTile(
                    title: Text(
                      'To The Client ($selectedUsername)',
                      style: TextStyle(
                          fontSize: FONT_XSS,
                          color: !isClientSelEnabled
                              ? SECONDARY_CLR
                              : NORMAL_TEXT_CLR),
                    ),
                    value: sendCalInvClient,
                    onChanged: (bool? value) {
                      if (isClientSelEnabled) {
                        setState(() {
                          sendCalInvClient = value ?? false;
                        });
                      }
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    checkColor: Colors.white,
                    activeColor:
                        Colors.green, // Customize the color of the checkmark
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (isLoading)
          const Opacity(
            opacity: 0.6,
            child: ModalBarrier(
                dismissible: false, color: Color.fromARGB(255, 0, 0, 0)),
          ),
        if (isLoading)
          const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
      ],
    );
  }
}
