import 'package:flutter/material.dart';
import 'package:flutter_app/constants/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class Utility {
  static showToast(String msg) {
    Fluttertoast.showToast(msg: msg);
  }

  static launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
