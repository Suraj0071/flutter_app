import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_app/backend/api_manager.dart';
import 'package:flutter_app/constants/constants.dart';
import 'package:flutter_app/modal/contact_model.dart';
import 'package:flutter_app/screens/nav_screens/contact_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/route_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewContact extends StatefulWidget {
  final id;
  NewContact({super.key, required this.id});

  @override
  State<NewContact> createState() => _NewContactState();
}

class _NewContactState extends State<NewContact> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _companyController = TextEditingController();
  final _workPhoneController = TextEditingController();
  bool hasErrorLastName = false;
  bool hasEmailError = false;
  bool _isLoading = false;
  var responseData, postResponse;
  List<ContactItems> data = [];
  String superCustomerID = "", compCode = "", accountId = "", roleId = "";
  String? ownerId, ownerName;
  bool hasError = false;

  void validateForm() {
    setState(() {
      hasEmailError = false;
      hasErrorLastName = false;
    });
    if (_lastNameController.text == "") {
      Get.snackbar(
        "Last Name is required",
        "Please enter Last Name.",
        colorText: DARK_ERROR_COLOR,
        backgroundColor: LIGHT_ERROR_COLOR,
        icon: const Icon(
          Icons.error,
          color: DARK_ERROR_COLOR,
        ),
      );
      setState(() {
        hasErrorLastName = true;
      });
      hasError = true;
    }

    if (_emailController.text != "") {
      String email = _emailController.text;

      final bool emailValid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(email);
      if (!emailValid) {
        Get.snackbar(
          "Invalid Email Address",
          "Please enter the valid email address.",
          colorText: DARK_ERROR_COLOR,
          backgroundColor: LIGHT_ERROR_COLOR,
          icon: const Icon(
            Icons.error,
            color: DARK_ERROR_COLOR,
          ),
        );
        hasError = true;
        setState(() {
          hasEmailError = true;
        });
      }
      // return;
    }
    if (hasError) return;

    sendDataToServer();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.id != null) {
      setState(() {
        _isLoading = true;
      });
      getData();
    }
  }

  void getData() async {
    responseData = await ApiManager(context)
        .getApiData("$BASE_URL/contact-update?id=${widget.id}");
    setState(() {
      for (var i in responseData["items"]) {
        data.add(ContactItems.fromJson(i));
      }
      _firstNameController.text = data[0].firstName ?? "";
      _lastNameController.text = data[0].lastName ?? "";
      _emailController.text = data[0].email ?? "";
      _companyController.text = data[0].company ?? "";
      _workPhoneController.text = data[0].workPhone ?? "";
      _mobileController.text = data[0].mobileNum ?? "";

      if (data[0].contactOwner != null) {
        int idx = data[0].contactOwner!.indexOf(" ");
        List parts = [
          data[0].contactOwner!.substring(0, idx).trim(),
          data[0].contactOwner!.substring(idx + 1).trim()
        ];

        setState(() {
          ownerId = parts[0];
          ownerName = parts[1];
        });
      }

      _isLoading = false;
    });
  }

  void sendDataToServer() async {
    setState(() {
      _isLoading = true;
    });
    superCustomerID = await ApiManager(context).getLocalData("super_cust_id");
    compCode = await ApiManager(context).getLocalData("comp_code");
    accountId = await ApiManager(context).getLocalData("account_id");
    roleId = await ApiManager(context).getLocalData("role_id");
    String? mobileNum, workMobileNum;
    if (_mobileController.text != null || _mobileController.text != "") {
      mobileNum = _mobileController.text.replaceAll('+', '*plus*');
    }
    if (_workPhoneController.text != null || _workPhoneController.text != "") {
      workMobileNum = _workPhoneController.text.replaceAll('+', '*plus*');
    }

    if (widget.id != null) {
      postResponse = await ApiManager(context).postApiData(
          "$BASE_URL/contact-update?acc_id=$accountId&lead_id=${widget.id}&super_cust_id=$superCustomerID&comp_code=$compCode&first_name=${_firstNameController.text}&last_name=${_lastNameController.text}&email=${_emailController.text}&phone=${mobileNum}&work_phone=${workMobileNum}&comp_name=${_companyController.text}&lead_owner_id=${ownerId!.trim()}");
      Get.snackbar(
        "Contact Updated",
        "${_firstNameController.text} ${_lastNameController.text} contact is updated.",
        colorText: DARK_SUCCESS_COLOR,
        backgroundColor: LIGHT_SUCCESS_COLOR,
        icon: const Icon(
          Icons.check,
          color: DARK_SUCCESS_COLOR,
        ),
      );
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('refreshFeed', 'Y');
      Navigator.pop(context, 'Y');
    } else {
      FocusScope.of(context).unfocus();
      postResponse = await ApiManager(context).postApiData(
          "$BASE_URL/contacts?acc_id=$accountId&lead_id=${widget.id}&super_cust_id=$superCustomerID&comp_code=$compCode&first_name=${_firstNameController.text}&last_name=${_lastNameController.text}&email=${_emailController.text}&mobile_num=${mobileNum}&work_mobile=${workMobileNum}&comp_name=${_companyController.text}");

      Get.snackbar(
        "Contact Created",
        "${_firstNameController.text} ${_lastNameController.text} contact is created.",
        colorText: DARK_SUCCESS_COLOR,
        backgroundColor: LIGHT_SUCCESS_COLOR,
        icon: const Icon(
          Icons.check,
          color: DARK_SUCCESS_COLOR,
        ),
      );
      Navigator.pop(context, 'Y');
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> sleepOneSecond() {
    return Future.delayed(Duration(seconds: 1));
  }

  Future<void> _selectOwner(BuildContext context) async {
    FocusScope.of(context).unfocus();
    // sleepOneSecond().then((_) async {
    final data = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ContactScreen(toSelectOwner: 'Y')),
    );
    if (data != null) {
      int idx = data.indexOf(" ");
      List parts = [
        data.substring(0, idx).trim(),
        data.substring(idx + 1).trim()
      ];

      setState(() {
        ownerId = parts[0];
        ownerName = parts[1];
      });
    }
    // });

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            leading: Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: DARK_TEXT_CLR,
                    fontSize: FONT_XSS,
                  ),
                ),
              ),
            ),
            title: Text(
              widget.id != null ? "Edit Contact" : "New Contact",
              style: const TextStyle(color: APPBAR_TXT_CLR, fontSize: FONT_SM),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // createContact();
                  // sendDataToServer();
                  hasError = false;
                  validateForm();
                },
                child: const Text(
                  'Done',
                  style: TextStyle(
                    color: DARK_TEXT_CLR,
                    fontSize: FONT_SM - 2,
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(PADDING_MD),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'First Name',
                    // style: TextStyle(fontSize: FONT_XSS, color: NORMAL_TEXT_CLR),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(
                      hintText: 'Add First Name',
                      hintStyle: TextStyle(color: SECONDARY_CLR),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: INPUT_BORDER_CLR, width: 1.0),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: INPUT_BORDER_CLR, width: 1.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: PADDING_SM,
                  ),
                  Text(
                    'Last Name',
                    // style: TextStyle(
                    //     fontSize: FONT_XSS,
                    //     color:
                    //         hasErrorLastName ? DARK_ERROR_COLOR : NORMAL_TEXT_CLR),
                    style: TextStyle(
                        fontSize: FONT_XSS,
                        color: hasErrorLastName
                            ? DARK_ERROR_COLOR
                            : NORMAL_TEXT_CLR),
                  ),
                  TextField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      hintText: 'Add Last Name',
                      hintStyle: TextStyle(
                          color: hasErrorLastName
                              ? DARK_HINT_COLOR
                              : SECONDARY_CLR),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: hasErrorLastName
                                ? DARK_ERROR_COLOR
                                : INPUT_BORDER_CLR,
                            width: 1.0),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: hasErrorLastName
                                ? DARK_ERROR_COLOR
                                : INPUT_BORDER_CLR,
                            width: 1.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: PADDING_SM,
                  ),
                  Text(
                    'Mobile',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextField(
                    controller: _mobileController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      hintText: 'Add Mobile',
                      hintStyle: TextStyle(color: SECONDARY_CLR),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: INPUT_BORDER_CLR, width: 1.0),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: INPUT_BORDER_CLR, width: 1.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: PADDING_SM,
                  ),
                  Text(
                    'Email',
                    style: TextStyle(
                        fontSize: FONT_XSS,
                        color:
                            hasEmailError ? DARK_ERROR_COLOR : NORMAL_TEXT_CLR),
                  ),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Add Email',
                      hintStyle: TextStyle(
                          color:
                              hasEmailError ? DARK_HINT_COLOR : SECONDARY_CLR),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: hasEmailError
                                ? DARK_ERROR_COLOR
                                : INPUT_BORDER_CLR,
                            width: 1.0),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: hasEmailError
                                ? DARK_ERROR_COLOR
                                : INPUT_BORDER_CLR,
                            width: 1.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: PADDING_SM,
                  ),
                  Text(
                    'Company',
                    // style: TextStyle(fontSize: FONT_XSS, color: NORMAL_TEXT_CLR),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextField(
                    controller: _companyController,
                    decoration: const InputDecoration(
                      hintText: 'Add Company',
                      hintStyle: TextStyle(color: SECONDARY_CLR),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: INPUT_BORDER_CLR, width: 1.0),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: INPUT_BORDER_CLR, width: 1.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: PADDING_SM,
                  ),
                  Text(
                    'Work Phone',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextField(
                    controller: _workPhoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      hintText: 'Add Phone',
                      hintStyle: TextStyle(color: SECONDARY_CLR),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: INPUT_BORDER_CLR, width: 1.0),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: INPUT_BORDER_CLR, width: 1.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: PADDING_SM,
                  ),
                  widget.id != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Owner*',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(
                              height: SIZE_SM + 2,
                            ),
                            GestureDetector(
                              onTap: () {
                                _selectOwner(context);
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                        ownerName == ""
                                            ? "Select Contact Owner"
                                            : ownerName ??
                                                "Select Contact Owner",
                                        style: TextStyle(
                                            fontSize: FONT_SM,
                                            color: ownerName != null
                                                ? NORMAL_TEXT_CLR
                                                : SECONDARY_CLR)),
                                  ),
                                  SvgPicture.asset(
                                      "assets/images/arrow_down_ic.svg")
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: SIZE_XS - 2,
                            ),
                            const Divider(
                              thickness: 1,
                            )
                          ],
                        )
                      : const SizedBox()
                ],
              ),
            ),
          ),
        ),
        if (_isLoading)
          const Opacity(
            opacity: 0.6,
            child: ModalBarrier(
                dismissible: false, color: Color.fromARGB(255, 0, 0, 0)),
          ),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
      ],
    );
  }
}
