import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/backend/api_manager.dart';
import 'package:flutter_app/modal/call_log_model.dart';
import 'package:flutter_app/screens/call_log.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_app/constants/constants.dart';
import 'package:flutter_app/screens/new_activity.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/route_manager.dart';

class CallSummary extends StatefulWidget {
  String? callLogId;
  CallSummary({super.key, required this.callLogId});

  @override
  State<CallSummary> createState() => _CallSummaryState();
}

class _CallSummaryState extends State<CallSummary> {
  String superCustomerID = "", compCode = "", accountId = "", roleId = "";
  var responseData, postRes;
  String? selectedOutcome = 'S';
  bool nextActivitySwitch = false;
  bool isLoading = false;
  bool hasError = false;
  String? contactName,
      callStatus,
      calldate,
      callDuration,
      leadId,
      leadOwnerId,
      leadOwnerName;
  final _noteController = TextEditingController();

  void getCallLogDetails() async {
    setState(() {
      isLoading = true;
    });
    superCustomerID = await ApiManager(context).getLocalData("super_cust_id");
    compCode = await ApiManager(context).getLocalData("comp_code");
    accountId = await ApiManager(context).getLocalData("account_id");
    roleId = await ApiManager(context).getLocalData("role_id");

    // https://devcrm20.abacasys.com/ords/as/mobile_api/call-log-detail
    responseData = await ApiManager(context).getApiData(
        "$BASE_URL/call-log-detail?acc_id=$accountId&call_id=${widget.callLogId}&super_cust_id=$superCustomerID&comp_code=$compCode");

    setState(() {
      callDuration = responseData['call_duration'];
      _noteController.text = responseData['note'];
      selectedOutcome = responseData['call_outcome'];
      callStatus = responseData['call_type'];
      contactName = responseData['lead_name'];
      calldate = responseData['call_time'];
      leadId = responseData['lead_id'];
      leadOwnerId = responseData['lead_owner_id'];
      leadOwnerName = responseData['lead_owner_name'];
      isLoading = false;
    });
  }

  String getCallStatusImg(status) {
    if (status == 'I') return "assets/images/incoming_icon.svg";
    if (status == 'O') return "assets/images/call_outgoing_ic.svg";
    if (status == 'M') return "assets/images/missed_call_icon.svg";
    // if (status == 'R') return "assets/images/reject_icon.svg";
    return "assets/images/incoming_icon.svg";
  }

  String getCallStatus(status) {
    if (status == 'I') return "Incoming Call";
    if (status == 'O') return "Outgoing Call";
    if (status == 'M') return "Missed Call";
    // if (status == 'R') return "assets/images/reject_icon.svg";
    return "Incoming Call";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCallLogDetails();
  }

  String getDuration(secs) {
    if (secs == "" || secs == null) return "";
    int minutes = (int.parse(secs) / 60).floor();
    int seconds = int.parse(secs) % 60;

    return '$minutes:$seconds';
  }

  void checkValidation() async {
    setState(() {
      hasError = true;
    });
    if (_noteController.text == "") {
      setState(() {
        hasError = true;
      });
      Get.snackbar(
        "Empty Note",
        "Notes must have some value.",
        colorText: DARK_ERROR_COLOR,
        backgroundColor: LIGHT_ERROR_COLOR,
        icon: const Icon(
          Icons.error,
          color: DARK_ERROR_COLOR,
        ),
      );
    } else {
      saveCallSummery();
    }
  }

  void saveCallSummery() async {
    setState(() {
      isLoading = true;
    });
    postRes = await ApiManager(context).postApiData(
        "$BASE_URL/call-log-detail?note=${_noteController.text}&outcome=$selectedOutcome&call_id=${widget.callLogId}");
    final data = jsonDecode(postRes.body);
    if (data['status'] == 'success') {
      Get.snackbar(
        "Call Summery Updated",
        "Call Summery Updated Successfull!",
        colorText: DARK_SUCCESS_COLOR,
        backgroundColor: LIGHT_SUCCESS_COLOR,
        icon: const Icon(
          Icons.check,
          color: DARK_SUCCESS_COLOR,
        ),
      );
    }
    setState(() {
      isLoading = false;
    });
    if (nextActivitySwitch) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NewActivity(
                  cntId: leadId,
                  cntName: contactName,
                  leadOwnerId: leadOwnerId,
                  leadOwnerName: leadOwnerName,
                  selectedAction: 'Call',
                )),
      );
    } else {
      Navigator.pop(context);
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
              child: Center(
                child: Text(
                  'Cancel',
                  style: TextStyle(fontSize: FONT_SM, color: NORMAL_TEXT_CLR),
                ),
              ),
            ),
            title: Text(
              'Call Summary',
              style: TextStyle(fontSize: FONT_SM + 2, color: NORMAL_TEXT_CLR),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // saveCallSummery();
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
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: PADDING_SM), // Adjust the value as needed
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        getCallStatusImg(callStatus),
                        width: 32,
                        height: 32,
                      ),
                      // SvgPicture.asset(
                      //   "assets/images/call_logo/outgoing_call_logo.svg",
                      // ),
                      const SizedBox(
                        width: SIZE_XXS,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(getCallStatus(callStatus),
                              style: const TextStyle(
                                  fontSize: FONT_SM + 2,
                                  color: NORMAL_TEXT_CLR)),
                          Text(
                              '$calldate • ${getDuration(callDuration)} minutes',
                              style: const TextStyle(
                                  fontSize: FONT_XSS, color: SECONDARY_CLR)),
                        ],
                      )
                    ],
                  ),
                ),
                // other elements in column
                TextField(
                  controller: _noteController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: CALL_SUMMARY_TX_BG,
                    hintText: 'Add your call notes here...',
                    hintStyle: TextStyle(
                        color: hasError ? DARK_HINT_COLOR : SECONDARY_CLR),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: hasError ? DARK_ERROR_COLOR : DARK_CLR,
                          width: 1.0),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: hasError ? DARK_ERROR_COLOR : DARK_CLR,
                          width: 1.0),
                    ),
                  ),
                  maxLines: 4, // Set the desired number of lines
                  textInputAction: TextInputAction.newline,
                ),

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButton<String>(
                        value: selectedOutcome,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedOutcome = newValue;
                          });
                        },
                        items: const [
                          DropdownMenuItem<String>(
                            value: 'S',
                            child: Text('Spoke with contact'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'L',
                            child: Text('Left a message'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'N',
                            child: Text('No Answer'),
                          ),
                        ],
                        isExpanded: true,
                      ),
                      SizedBox(
                        height: SIZE_MD,
                      ),
                      Text('Contact Name',
                          style: TextStyle(
                              fontSize: FONT_XSS, color: SECONDARY_CLR)),
                      SizedBox(
                        height: SIZE_XS,
                      ),
                      Text(
                        contactName ?? NOT_PROVIDED,
                        style: TextStyle(
                            color: contactName == null || contactName == ""
                                ? SECONDARY_CLR
                                : NORMAL_TEXT_CLR,
                            fontSize: contactName == null || contactName == ""
                                ? FONT_XSS
                                : FONT_SM),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      SizedBox(
                        height: SIZE_MD,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text('Schedule next activity',
                                style: TextStyle(
                                    fontSize: FONT_SM, color: NORMAL_TEXT_CLR)),
                          ),
                          CupertinoSwitch(
                            value: nextActivitySwitch,
                            onChanged: (value) {
                              setState(
                                () {
                                  nextActivitySwitch = value;
                                },
                              );
                            },
                            thumbColor: CupertinoColors.systemBackground,
                            activeColor: Color(0xFF63D36C),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: SIZE_MD,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: CALL_SUMMARY_TX_BG_1,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.all(PADDING_XS),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              "assets/images/call_logo/info_icon.svg",
                            ),
                            SizedBox(width: PADDING_XS),
                            Expanded(
                              child: Text(
                                'You will be prompted to schedule a follow-up activity each time you complete the last one.',
                                style: TextStyle(
                                    fontSize: FONT_XS, color: NORMAL_TEXT_CLR),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
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
