import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/constants/constants.dart';
import 'package:flutter_app/modal/call_log_model.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ApiManager {
  BuildContext? context;

  ApiManager(BuildContext context) {
    this.context = context;
  }

  static Future<bool> checkInternet() async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> getApiData(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch data from the API');
      }
    } catch (e) {
      throw Exception('An error occurred while making the API request: $e');
    }
  }

  Future<http.Response> postApiData(String url) async {
    try {
      final response = await http.post(Uri.parse(url));

      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('Failed to post data to the API');
      }
    } catch (e) {
      throw Exception('An error occurred while making the API request: $e');
    }
  }

  getLocalData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString(key) ?? "";
    return stringValue;
  }

  logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("loggedInEmail");
    prefs.remove("loggedInPasswrd");
    prefs.remove("super_cust_id");
    prefs.remove("comp_code");
    prefs.remove("account_id");
    prefs.remove("role_id");
    return true;
  }

  // launchURL(stUrl) async {
  //   Uri _url = Uri.parse("stUrl");
  //   if (await launchURL(_url)) {
  //     await launchUrl(_url);
  //   } else {
  //     throw 'Could not launch $_url';
  //   }
  // }
}
