import 'package:auto_size_text/auto_size_text.dart';
import 'package:facto_user/util/colors.dart';
import 'package:facto_user/util/globals.dart';
import 'package:facto_user/util/images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'dart:math' as math;
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Toast.show('Internet Connection Error. Please try again.', context);
    }
  }

  Future<void> _webViewDialog(String url) {
    return showDialog<void>(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)),
          backgroundColor: Colors.white,
          content: Container(
              height: Globals.height * 0.7,
              width: Globals.width,
              child: WebView(
                initialUrl: url,
              )),
          actions: [
            TextButton(onPressed: (){
              Navigator.pop(context);
            }, child: (Text('Dismiss')))
          ],));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
              top: 0.0,
              right: 0.0,
              child: Container(
                width: Globals.width,
                height: Globals.height * 0.4,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(Images.sign_in_background_pattern),
                        fit: BoxFit.cover)),
              )),
          Positioned(
              bottom: 0.0,
              left: 0.0,
              child: Transform.rotate(
                child: Container(
                  width: Globals.width,
                  height: Globals.height * 0.4,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(Images.sign_in_background_pattern),
                          fit: BoxFit.cover)),
                ),
                angle: math.pi,
              )),
          Positioned(
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 48,
              ),
            ),
            top: Globals.height * 0.05,
            left: Globals.width * 0.02,
          ),
          Positioned(
              top: Globals.height * 0.06,
              left: Globals.width * 0.384,
              child: Container(
                width: Globals.width * 0.234,
                height: Globals.height * 0.027,
                child: AutoSizeText(
                  'About Us',
                  style: GoogleFonts.montserrat(
                      fontSize: 22, fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
              )),
          Positioned(
              top: Globals.height * 0.15,
              left: Globals.width * 0.249,
              child: Container(
                width: Globals.width * 0.504,
                height: Globals.height * 0.09,
                decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage(Images.logo))),
              )),
          Positioned(
              top: Globals.height * 0.25,
              left: Globals.width * 0.15,
              child: Container(
                  height: Globals.height * 0.3,
                  width: Globals.width * 0.7,
                  child: ReadMoreText(
                    'FactO News of  FACTO Digital Media (OPC) Private Limited is an independent fact-checking platform committed to fighting misinformation/disinformation, false and fake news that we come across social media and mainstream media. We provide our readers with verified facts and educate them on issues that focus on but not limited to political, communal, and social aspects.',
                    trimLines: 5,
                    style: GoogleFonts.montserrat(
                        fontSize: 16,
                        color: ColorStyle.text_Color,
                        fontWeight: FontWeight.w400),
                    colorClickableText: Colors.red,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'Read more',
                    trimExpandedText: 'Show less',
                    moreStyle:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ))),
          Positioned(
              top: Globals.height * 0.618,
              left: Globals.width * 0.05,
              child: Row(
                children: [
                  Container(
                      width: Globals.width * 0.425,
                      height: Globals.height * 0.07,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: const Offset(2.0, 2.0),
                              blurRadius: 10.0,
                              spreadRadius: 2.0,
                            ), //BoxShadow
                            BoxShadow(
                              color: Colors.white,
                              offset: const Offset(0.0, 0.0),
                              blurRadius: 0.0,
                              spreadRadius: 0.0,
                            ),
                          ]),
                      child: TextButton(
                        onPressed: () async {
                          _webViewDialog('https://facto.co.in/contact-us/');
                        },
                        child: AutoSizeText(
                          'Contact Us',
                          style: GoogleFonts.montserrat(
                              fontSize: 20, color: ColorStyle.text_Color),
                        ),
                      )),
                  SizedBox(width: Globals.width * 0.05),
                  Container(
                      width: Globals.width * 0.425,
                      height: Globals.height * 0.07,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: const Offset(2.0, 2.0),
                              blurRadius: 10.0,
                              spreadRadius: 2.0,
                            ), //BoxShadow
                            BoxShadow(
                              color: Colors.white,
                              offset: const Offset(0.0, 0.0),
                              blurRadius: 0.0,
                              spreadRadius: 0.0,
                            ),
                          ]),
                      child: TextButton(
                        onPressed: () async {
                          await _launchURL(
                              'https://play.google.com/store/apps/details?id=com.codingdevs.facto_user');
                        },
                        child: AutoSizeText(
                          'Rate',
                          style: GoogleFonts.montserrat(
                              fontSize: 20, color: ColorStyle.text_Color),
                        ),
                      ))
                ],
              )),
          Positioned(
            top: Globals.height * 0.7401,
            left: Globals.width * 0.2906,
            child: Container(
                width: Globals.width * 0.4186,
                height: Globals.height * 0.07,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: const Offset(2.0, 2.0),
                        blurRadius: 5.0,
                        spreadRadius: 1.0,
                      ), //BoxShadow
                      BoxShadow(
                        color: Colors.white,
                        offset: const Offset(0.0, 0.0),
                        blurRadius: 0.0,
                        spreadRadius: 0.0,
                      ),
                    ]),
                child: TextButton(
                  onPressed: () async {
                    print('this.button');
                    await _launchURL('mailto:contact@factonews.co');
                  },
                  child: AutoSizeText(
                    'FeedBack',
                    style: GoogleFonts.montserrat(
                        fontSize: 20, color: ColorStyle.text_Color),
                  ),
                )),
          ),
          Positioned(
              top: Globals.height * 0.88546,
              left: Globals.width * 0.1,
              child: Container(
                width: Globals.width * 0.8,
                child: Divider(
                  thickness: 1.0,
                  color: Colors.black,
                ),
              )),
          Positioned(
              top: Globals.height * 0.9125,
              left: Globals.width * 0.1486,
              child: Container(
                width: Globals.width * (70/375),
                height: Globals.height * (30/812),
                child: TextButton(
                  onPressed: () {
                    _webViewDialog('http://factonews.co/privacy-policy/');
                  },
                  child: AutoSizeText(
                    'Privacy',
                    style: GoogleFonts.montserrat(color: ColorStyle.text_Color),
                  ),
                ),
              )),
          Positioned(
              top: Globals.height * 0.9125,
              left: Globals.width * 0.362,
              child: Container(
                width: Globals.width * (110/375),
                height: Globals.height * (30/812),
                child: TextButton(
                  onPressed: () {},
                  child: AutoSizeText(
                    '© ${DateTime.now().year} FACTO™',
                    style: GoogleFonts.montserrat(color: ColorStyle.text_Color),
                  ),
                ),
              )),
          Positioned(
              top: Globals.height * 0.9125,
              left: Globals.width * 0.7306,
              child: Container(
                width: Globals.width * (60/375),
                height: Globals.height * (32/812),
                child: TextButton(
                  onPressed: () {
                    _webViewDialog('https://factonews.co/code-of-principles/');
                  },
                  child: AutoSizeText(
                    'T&C',
                    style: GoogleFonts.montserrat(color: ColorStyle.text_Color),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
