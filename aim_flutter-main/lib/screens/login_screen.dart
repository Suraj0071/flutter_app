import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/backend/api_manager.dart';
import 'package:flutter_app/bottom_navbar.dart';
import 'package:flutter_app/constants/constants.dart';
import 'package:flutter_app/modal/LoginUserModal.dart';
import 'package:flutter_app/screens/home_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:crypto/crypto.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get/utils.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisible = false;
  bool _showProgressBar = false;
  bool _emailError = false;
  bool _passwordError = false;
  late AnimationController _animcontroller;
  late Animation<Offset> _offsetcontainer;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() async {
    if (_emailController.text == "" && _passwordController.text == "") {
      // ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text("Please enter the email and password")));
      Get.snackbar(
        "Invalid Email & Password",
        "Please enter the email and password",
        colorText: DARK_ERROR_COLOR,
        backgroundColor: LIGHT_ERROR_COLOR,
        icon: const Icon(
          Icons.error,
          color: DARK_ERROR_COLOR,
        ),
      );
      setState(() {
        _emailError = true;
        _passwordError = true;
      });
      return;
    }

    if (_emailController.text == "") {
      // ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text("Please enter the email")));
      Get.snackbar(
        "Invalid Email",
        "Please enter the email",
        colorText: DARK_ERROR_COLOR,
        backgroundColor: LIGHT_ERROR_COLOR,
        icon: const Icon(
          Icons.error,
          color: DARK_ERROR_COLOR,
        ),
      );
      setState(() {
        _emailError = true;
      });
      return;
    }

    if (_passwordController.text == "") {
      // ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text("Please enter the password")));
      Get.snackbar(
        "Invalid Password",
        "Please enter the password",
        colorText: DARK_ERROR_COLOR,
        backgroundColor: LIGHT_ERROR_COLOR,
        icon: const Icon(
          Icons.error,
          color: DARK_ERROR_COLOR,
        ),
      );
      setState(() {
        _passwordError = true;
      });
      return;
    }

    setState(() {
      _showProgressBar = true;
    });
    var encryptedPassword = md5
        .convert(utf8.encode(
            _emailController.text.toLowerCase() + _passwordController.text))
        .toString()
        .toUpperCase();
    final emailAddress = _emailController.text;
    // print(_encryptedPassword.toUpperCase() + emailAddress);
    final response = await http.get(
      Uri.parse(
          '$BASE_URL/authentication?EMAIL=${emailAddress.toLowerCase()}&PASSWORD=$encryptedPassword'),
    );
    final finalStatus = json.decode(response.body)["status"];
    final fullName = json.decode(response.body)["full_name"];
    final superCustId = json.decode(response.body)["super_cust_id"];
    final compCode = json.decode(response.body)["comp_code"];
    final roleId = json.decode(response.body)["role_id"];
    final accountId = json.decode(response.body)["account_id"];

    setState(() {
      _showProgressBar = false;
    });

    // _emailController.clear();
    // _passwordController.clear();
    if (finalStatus == 'SUCCESS') {
      saveCredsToSF(emailAddress, encryptedPassword, superCustId, compCode,
          accountId, roleId, fullName);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => BottomNavBar()));
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text("Invalid username or password")));
      Get.snackbar(
        "Invalid Credentials",
        "Please check your credentials",
        colorText: DARK_ERROR_COLOR,
        backgroundColor: LIGHT_ERROR_COLOR,
        icon: const Icon(
          Icons.error,
          color: DARK_ERROR_COLOR,
        ),
      );
      setState(() {
        _emailError = true;
        _passwordError = true;
      });
    }
  }

  saveCredsToSF(email, passwrd, superCustId, compCode, accountId, roleId,
      fullName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('loggedInEmail', email);
    prefs.setString('loggedInPasswrd', passwrd);
    prefs.setString('super_cust_id', superCustId);
    prefs.setString('comp_code', compCode);
    prefs.setString('account_id', accountId);
    prefs.setString('role_id', roleId);
    prefs.setString('full_name', fullName);
  }

  @override
  void initState() {
    _passwordVisible = false;
    _showProgressBar = false;
    _animcontroller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 660));

    _offsetcontainer =
        Tween<Offset>(begin: Offset(0.0, 2.0), end: Offset(0.0, 0.8))
            .animate(_animcontroller);
    _animcontroller.forward();
  }

  launchPrivacyPol() async {
    Uri _url = Uri.parse("https://abacaaim.com/privacy-policy/");
    if (await launchUrl(_url)) {
      await launchUrl(_url);
    } else {
      throw 'Could not launch $_url';
    }
  }

  launchTerms() async {
    Uri _url = Uri.parse("https://abacaaim.com/terms-of-service/");
    if (await launchUrl(_url)) {
      await launchUrl(_url);
    } else {
      throw 'Could not launch $_url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFCC4242),
      body: SafeArea(
          child: Stack(
        children: [
          Positioned(
            child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: SvgPicture.asset("images/login_bg_struct.svg")),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.46,
            child: Padding(
              padding: const EdgeInsets.only(left: 28.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset("images/abaca_white_logo.svg"),
                  const SizedBox(
                    height: 40,
                  ),
                  const Text(
                    "Evolve Your Marketing & Sales",
                    style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 28),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.54,
              decoration: const BoxDecoration(
                  color: Color(0xFFFAFAFA),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0))),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 24, right: 24, top: 36, bottom: 24),
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Log in",
                        style: TextStyle(fontSize: 36),
                      ),
                      // Row(
                      //   // ignore: prefer_const_literals_to_create_immutables
                      //   children: [
                      //     const Text("New user?"),
                      //     const TextButton(
                      //         onPressed: null,
                      //         child: Text(
                      //           "Create an account",
                      //           style: TextStyle(color: Color(0xFF5B6EBC)),
                      //         ))
                      //   ],
                      // ),
                      const SizedBox(
                        height: SIZE_MD,
                      ),
                      TextField(
                        controller: _emailController,
                        autofocus: false,
                        cursorColor: NORMAL_TEXT_CLR,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (text) {
                          setState(() {
                            _emailError = false;
                          });
                        },
                        style: const TextStyle(
                            fontSize: 16.0,
                            color: Color.fromARGB(255, 41, 41, 41)),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Email Address',
                          contentPadding: const EdgeInsets.only(
                              left: 14.0, bottom: 8.0, top: 8.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: _emailError
                                    ? DARK_ERROR_COLOR
                                    : FOCUSED_INPUT_BORDER_CLR),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: _emailError
                                    ? DARK_ERROR_COLOR
                                    : INPUT_BORDER_CLR,
                                width: 1.0),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: _passwordController,
                        obscureText: !_passwordVisible,
                        autofocus: false,
                        cursorColor: NORMAL_TEXT_CLR,
                        onChanged: (text) {
                          setState(() {
                            _passwordError = false;
                          });
                        },
                        style: const TextStyle(
                            fontSize: 16.0,
                            color: Color.fromARGB(255, 41, 41, 41)),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Password',
                          contentPadding: const EdgeInsets.only(
                              left: 14.0, bottom: 8.0, top: 8.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: _passwordError
                                    ? DARK_ERROR_COLOR
                                    : FOCUSED_INPUT_BORDER_CLR),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: _passwordError
                                    ? DARK_ERROR_COLOR
                                    : INPUT_BORDER_CLR,
                                width: 1.0),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: NORMAL_TEXT_CLR,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: PADDING_XS - 2,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // const TextButton(
                          //   onPressed: null,
                          //   child: Text(
                          //     "Forgot password?",
                          //     style: TextStyle(color: Color(0xFF47464A)),
                          //   ),
                          // ),
                          const SizedBox(
                            width: 46,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.38,
                            child: ElevatedButton(
                              onPressed: _onLogin,
                              child: Text(
                                "Login",
                                style: TextStyle(color: Colors.white),
                              ),
                              style: const ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      Color(0xFF092C4C))),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: PADDING_XS),
                        // child: Text(
                        //     "Protected by reCAPTCHA and subject to the Privacy Policy and Terms of Service."),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                  text:
                                      'Protected by reCAPTCHA and subject to the ',
                                  style: TextStyle(
                                      color: SECONDARY_CLR,
                                      fontSize: FONT_XSS)),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: const TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.none,
                                    fontSize: FONT_XSS),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = launchPrivacyPol,
                              ),
                              const TextSpan(
                                  text: ' and ',
                                  style: TextStyle(
                                      color: SECONDARY_CLR,
                                      fontSize: FONT_XSS)),
                              TextSpan(
                                text: 'Terms of Service.',
                                style: const TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.none,
                                    fontSize: FONT_XSS),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = launchTerms,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
          ),
          if (_showProgressBar)
            const Opacity(
              opacity: 0.6,
              child: ModalBarrier(
                  dismissible: false, color: Color.fromARGB(255, 0, 0, 0)),
            ),
          if (_showProgressBar)
            const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
        ],
      )),
    );
  }
}
