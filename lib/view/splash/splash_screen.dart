import 'dart:async';

import 'package:facto_user/util/globals.dart';
import 'package:facto_user/util/images.dart';
import 'package:facto_user/view/auth/sign_in.dart';
import 'package:facto_user/view/dashboard/dashboard.dart';
import 'package:facto_user/view/home_screen/home_screen.dart';
import 'package:facto_user/view/welcome/welcome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool language;

  @override
  void initState() {
    super.initState();
    _getLanguagePreferences();
  }

  _getLanguagePreferences() async {
    try{
      SharedPreferences preferences = await SharedPreferences.getInstance();
      language = preferences.getBool('language');
    }
    catch(e){
      Toast.show('Internet Connection Error', context,duration: Toast.LENGTH_LONG);
    }
    if (language == null) {
      Timer timer = new Timer(new Duration(milliseconds: 1000), () {
        Navigator.of(context)
            .pushReplacement(new MaterialPageRoute(builder: (context) {
          return WelcomeScreen();
        }));
      });
    } else {
      Timer timer = new Timer(new Duration(milliseconds: 1000), () {
          Navigator.of(context)
              .pushReplacement(new MaterialPageRoute(builder: (context) {
            return HomeScreen();
          }));

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Image.asset(
            Images.logo,
            width: Globals.width * 0.9 * 0.7,
            height: Globals.height * 0.2 * 0.7,
          ),
        )));
  }
}
