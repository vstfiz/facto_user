import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:facto_user/util/globals.dart';
import 'package:facto_user/util/images.dart';
import 'package:facto_user/view/dashboard/dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sms/generated/i18n.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Details extends StatefulWidget {
  final String url;

  Details(this.url);

  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State <Details>{
  bool isLoading = true;

  Widget _loadingScreen(String value) {
    return
      AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)),
          backgroundColor: Colors.white,
          content: Container(
              height: Globals.getHeight(80),
              child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(Images.logo,width: Globals.getWidth(100),height: Globals.getHeight(50),),

                      Container(child:  LinearProgressIndicator(
                        backgroundColor: Colors.grey,
                        valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.blueGrey),
                      ),width: Globals.getWidth(200))
                    ],
                  )
              )));
  }
  Widget build(BuildContext context){
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
        elevation: 15,
        automaticallyImplyLeading: false,
        actions: [
          Container(
              width: Globals.width,
              height: Globals.height * (54 / 812),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                  color: Colors.white),
              child: Stack(
                children: [
                  Positioned(
                    left: Globals.width * (8 / 375),
                    top: Globals.height * (9 / 812),
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Image.asset(
                          Images.back_btn,
                          height: Globals.height * (19 / 812),
                          width: Globals.width * (13 / 375),
                          color: Colors.black,
                        )),
                  ),
                  Positioned(
                      left: Globals.width * (23 / 375),
                      top: Globals.height * (12 / 812),
                      child: Container(
                        width: Globals.width * (60 / 375),
                        height: Globals.height * (30 / 812),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: AutoSizeText(
                            'Feed',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 14),
                          ),
                        ),
                      )),
                  Positioned(
                    left: Globals.width * (137 / 375),
                    top: 10,
                    child: Container(
                      width: Globals.width * (100 / 375),
                      height: Globals.height * (39 / 812),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(Images.logo), fit: BoxFit.contain)),
                    ),
                  ),
                ],
              ),
            )
        ],
      ),
        body: Stack(
          children: [
            Positioned(top: Globals.height * (5/812),left: 0.0,child: Container(
              width: Globals.width,
              height: Globals.height * 0.9,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: const Offset(5.0, 5.0),
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                    ), //BoxShadow
                    BoxShadow(
                      color: Colors.white,
                      offset: const Offset(0.0, 0.0),
                      blurRadius: 0.0,
                      spreadRadius: 0.0,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(80)
              ),
              child: WebView(
                initialUrl: this.widget.url,
                onPageFinished: (finished){
                  print(finished.length);
                  setState((){
                    isLoading = false;
                  });
                },
              ),
            )),
            isLoading?_loadingScreen('Loading....'):Container(),
          ],
        )

    ),top: true,);
  }
}