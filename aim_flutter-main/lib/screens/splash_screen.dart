import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_app/bottom_navbar.dart';
import 'package:flutter_app/screens/home_screen.dart';
import 'package:flutter_app/screens/login_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_app/constants/constants.dart' as Constants;
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    getStringValuesSF().then((value) => {
          // print(value),
          Timer(
              const Duration(seconds: 3),
              () => {
                    if (value == "")
                      {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()))
                      }
                    else
                      {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const BottomNavBar()))
                      }
                  })
        });
  }

  Future<String> getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String stringValue = prefs.getString('loggedInEmail') ?? "";
    return stringValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCC4242),
      body: Stack(
        children: [
          Positioned(
            child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: SvgPicture.asset("images/login_bg_struct.svg")),
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset("images/abaca_white_logo.svg"),
                const SizedBox(
                  height: 40.0, //Constants.spacing_lg,
                ),
                const SizedBox(
                  height: 46,
                ),
                const Text(
                  "Evolve Your Marketing & Sales.",
                  style: TextStyle(color: Colors.white, fontSize: 32),
                ),
                const SizedBox(
                  height: 60,
                ),
                Column(children: [
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: Colors.white,
                        size: 24.0,
                        semanticLabel:
                            'Text to announce in accessibility modes',
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      const Text(
                        "Lead Management",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ) //  Automation Sales Forecasting Sales & Marketing Funnel Optimization Ads & Social Connect
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: Colors.white,
                        size: 24.0,
                        semanticLabel:
                            'Text to announce in accessibility modes',
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      const Text(
                        "Sales force & Marketing",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ) // Sales force & Marketing Automation Sales Forecasting Sales & Marketing Funnel Optimization Ads & Social Connect
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: Colors.white,
                        size: 24.0,
                        semanticLabel:
                            'Text to announce in accessibility modes',
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      const Text(
                        "Automation Sales",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ) // Sales force & Marketing Automation Sales Forecasting Sales & Marketing Funnel Optimization Ads & Social Connect
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: Colors.white,
                        size: 24.0,
                        semanticLabel:
                            'Text to announce in accessibility modes',
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      const Text(
                        "Forecasting Sales & Marketing",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ) // Sales force & Marketing Automation Sales Forecasting Sales & Marketing Funnel Optimization Ads & Social Connect
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: Colors.white,
                        size: 24.0,
                        semanticLabel:
                            'Text to announce in accessibility modes',
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      const Text(
                        "Funnel Optimization",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ) // Sales force & Marketing Automation Sales Forecasting Sales & Marketing Funnel Optimization Ads & Social Connect
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: Colors.white,
                        size: 24.0,
                        semanticLabel:
                            'Text to announce in accessibility modes',
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      const Text(
                        "Ads & Social Connect",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ) // Sales force & Marketing Automation Sales Forecasting Sales & Marketing Funnel Optimization Ads & Social Connect
                    ],
                  ),
                ])
              ],
            ),
          )
        ],
      ),
    );
    ;
  }
}
