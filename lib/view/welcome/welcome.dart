import 'package:auto_size_text/auto_size_text.dart';
import 'package:facto_user/util/globals.dart';
import 'package:facto_user/util/images.dart';
import 'package:facto_user/view/auth/sign_in.dart';
import 'package:facto_user/view/dashboard/dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            height: Globals.height,
            width: Globals.width,
          ),
          Positioned(
              top: 0.0, left: 0.0, child: Container(
            width: Globals.width,
            height: Globals.height * 0.4,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(Images.languages_upper),
                  fit: BoxFit.cover,
              ),
            ),
          )),
          Positioned(
              bottom: 0.0, left: 0.0, child: Container(
            width: Globals.width,
            height: Globals.height * 0.4,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Images.languages_lower),
                fit: BoxFit.cover,
              ),
            ),
          )),
          Positioned(
              top: Globals.height * 0.3891,
              left: 0.0,
              child: Container(
                width: Globals.width,
                child: AutoSizeText('Welcome!',
                    style: GoogleFonts.montserrat(fontSize: 32,),textAlign: TextAlign.center,),
              )),
          Positioned(
              top: Globals.height * 0.5221667,
              left: 0.0,
              child: Container(
                width: Globals.width,
                child: Text(
                  'Choose your\nlanguage',
                  style: GoogleFonts.montserrat(fontSize: 28, fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
              )),
          Positioned(top:Globals.height * 0.1369999,left: Globals.width * 0.226666667,child: Container(height: Globals.height * 0.25,
            width: Globals.width * 0.54666666,
            decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage(Images.languages))),)),
          Positioned(
              left: Globals.width * 0.04,
              top: Globals.height * 0.71,
              child: Container(
                width: Globals.width * 0.9,
                child: Row(
                  children: [
                    Container(
                      height: Globals.height * 0.0716,
                      width: Globals.width * 0.435,
                      decoration: BoxDecoration(
                          color: Color(0xFFB01628),
                          borderRadius: BorderRadius.circular(Globals.width * 0.435 * 0.167)),
                      child: TextButton(
                        child: Text('English',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                        onPressed: () async {
                          try {
                            SharedPreferences preferences = await SharedPreferences
                                .getInstance();
                            await preferences.setBool('language', true);
                            Navigator.of(context).pushReplacement(
                                new MaterialPageRoute(builder: (context) {
                                  return SignIn();
                                }));
                          }
                          catch (e) {
                            Toast.show('Internet Connection Error', context,
                                duration: Toast.LENGTH_LONG);
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: Globals.width * 0.027,
                    ),
                    Container(
                      height: Globals.height * 0.0716,
                      width: Globals.width * 0.435,
                      decoration: BoxDecoration(
                          color: Color(0xFFB01628),
                          borderRadius: BorderRadius.circular(Globals.width * 0.435 * 0.167)),
                      child: TextButton(
                        child: Text(
                          'Hindi',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () async {
                          try {
                            SharedPreferences preferences = await SharedPreferences
                                .getInstance();
                            await preferences.setBool('language', false);
                            Navigator.of(context).pushReplacement(
                                new MaterialPageRoute(builder: (context) {
                                  return SignIn();
                                }));
                          }
                          catch (e) {
                            Toast.show('Internet Connection Error', context,
                                duration: Toast.LENGTH_LONG);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ))
        ],
      ),
    ));
  }
}
