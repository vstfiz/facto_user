import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:facto_user/database/firebase.dart';
import 'package:facto_user/util/colors.dart';
import 'package:facto_user/util/globals.dart';
import 'package:facto_user/util/images.dart';
import 'package:facto_user/view/edit_profile/edit_profile.dart';
import 'package:facto_user/view/file_claim/file_claim.dart';
import 'package:facto_user/view/search/search.dart';
import 'package:facto_user/view/user_profile/list_claim.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool isLoading = true;


  Widget _loadingDialog(String value) {
    return
      AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)),
          backgroundColor: Colors.white,
          content: Container(
              height: Globals.getHeight(150),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(Images.logo_loading,width: Globals.getWidth(100),height: Globals.getHeight(100),),
                    Row(

                      children: <Widget>[
                        CircularProgressIndicator(
                          valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.blueGrey),
                        ),
                        SizedBox(
                          width: Globals.getWidth(20),
                        ),
                        Text(
                          value,
                          style: TextStyle(
                              fontFamily: "Livvic",
                              fontSize: 23,
                              letterSpacing: 1),
                        )
                      ],
                    )
                  ],
                ),
              )));
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  int pendingCount;
  int completeCount;
  int rejectedCount;
  int totalCount;

  _getData() async {
    var val = await FirebaseDB.getCompletedCount();
    pendingCount = await FirebaseDB.getInProgress();
    setState(() {
      completeCount = val[0] + val[1];
      totalCount = pendingCount + completeCount;
      rejectedCount = val[1];
      isLoading = false;
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading?_loadingDialog('Loading Data'):Stack(
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
                  height: Globals.height * 0.45,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(Images.sign_in_background_pattern),
                          fit: BoxFit.cover)),
                ),
                angle: math.pi,
              )),
          Positioned(
              top: Globals.height * 0.05,
              left: Globals.width * 0.01,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.grey[800],
                  size: 48,
                ),
              )),
          Positioned(
              top: Globals.height * 0.05,
              right: Globals.width * 0.01,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(new MaterialPageRoute(builder: (context){return EditProfile();}));
                },
                icon: new Image.asset(Images.edit_profile,height: Globals.height * (33/812),width: Globals.width * (33/375),)
              )),
          Positioned(
              top: Globals.height * (92 / 812),
              left: Globals.width * (138 / 375),
              child: Container(
                height: Globals.height * (100 / 812),
                width: Globals.width * (100 / 375),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            Globals.user.dp),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(
                        Globals.width * (100 / 375) * (36 / 100))),
              )),
          Positioned(
            top: Globals.height * (169 / 812),
            left: Globals.width * (34 / 375),
            child: Container(
              width: Globals.width * (197 / 375),
              height: Globals.height * (150 / 812),
              child: AutoSizeText(
                'Hi!\n${Globals.user.name.split(" ")[0]}.',
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w300, fontSize: 56),
              ),
            ),
          ),
          Positioned(
              top: Globals.height * (309 / 812),
              left: Globals.width * (60.3 / 375),
              child: Container(
                width: Globals.width * (250 / 375),
                height: Globals.height * (52 / 812),
                decoration: BoxDecoration(
                    color: ColorStyle.button_red,
                    borderRadius:
                    BorderRadius.circular(Globals.width * (28 / 375))),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(new MaterialPageRoute(builder: (context) {
                      return FileClaim();
                    }));
                  },
                  child: Stack(
                    children: [
                      Positioned(
                        top: Globals.height * (10 / 812),
                        left: Globals.width * (15 / 375),
                        child: Container(
                          width: Globals.width * (181 / 375),
                          height: Globals.height * (30 / 812),
                          child: AutoSizeText(
                            'Request Fact Check',
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w300,
                                color: Colors.white,
                                fontSize: 18),
                          ),
                        ),
                      ),
                      Positioned(
                          top: Globals.height * (7 / 812),
                          right: Globals.width * (15 / 375),
                          child: Image.asset(
                            Images.bar_search_icon,
                            width: Globals.width * (23 / 375),
                            height: Globals.height * (25 / 812),
                          ))
                    ],
                  ),
                ),
              )),
          Positioned(
              left: Globals.width * (33 / 375),
              top: Globals.height * (393 / 812),
              child: GestureDetector(
                onTap: (){
                  Navigator.of(context).push(new MaterialPageRoute(builder: (context){
                    return ListClaims('Total');
                  }));
                },
                child: Container(
                  width: Globals.width * (139 / 375),
                  height: Globals.height * (172 / 812),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          Globals.width * (10 / 375)),
                      color: ColorStyle.total_requests.withOpacity(0.2)),
                  child: Stack(
                    children: [
                      Positioned(
                          top: Globals.height * (28/812),
                          child: Container(height: Globals.height * (44/812),
                            width: Globals.width * (139/375), child: AutoSizeText(
                              totalCount.toString(),
                              style: GoogleFonts.montserrat(
                                  fontSize: 36, color: ColorStyle.text_Color),textAlign: TextAlign.center,
                            ),)),
                      Positioned(
                          bottom: Globals.height * (42/812),
                          left: Globals.width * (28/375),
                          child: Container(height: Globals.height * (44/812),
                            width: Globals.width * (84/375), child: AutoSizeText(
                              'Total\nRequests',
                              style: GoogleFonts.montserrat(
                                  fontSize: 36, color: ColorStyle.text_Color),textAlign: TextAlign.center,
                            ),)),
                    ],
                  ),
                ),
              )),
          Positioned(
              right: Globals.width * (30 / 375),
              top: Globals.height * (393 / 812),
              child: GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(new MaterialPageRoute(builder: (context){
                      return ListClaims('Completed');
                    }));
                  },
                  child: Container(
                width: Globals.width * (139 / 375),
                height: Globals.height * (172 / 812),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        Globals.width * (10 / 375)),
                    color: ColorStyle.completed.withOpacity(0.2)),
                child: Stack(
                  children: [
                    Positioned(
                        top: Globals.height * (28/812),

                        child: Container(height: Globals.height * (44/812),
                          width: Globals.width * (139/375), child: AutoSizeText(
                            completeCount.toString(),
                            style: GoogleFonts.montserrat(
                                fontSize: 36, color: ColorStyle.text_Color),textAlign: TextAlign.center,
                          ),)),
                    Positioned(
                        bottom: Globals.height * (42/812),
                        left: Globals.width * (20/375),
                        child: Container(height: Globals.height * (44/812),
                          width: Globals.width * (100/375), child: AutoSizeText(
                            'Completed',
                            style: GoogleFonts.montserrat(
                                fontSize: 36, color: ColorStyle.text_Color),textAlign: TextAlign.center,
                          ),)),
                  ],
                ),
              ))),
          Positioned(
              left: Globals.width * (33 / 375),
              top: Globals.height * (577 / 812),
              child: GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(new MaterialPageRoute(builder: (context){
                      return ListClaims('Rejected');
                    }));
                  },
                  child: Container(
                width: Globals.width * (139 / 375),
                height: Globals.height * (172 / 812),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        Globals.width * (10 / 375)),
                    color: ColorStyle.rejected.withOpacity(0.2)),
                  child: Stack(
                    children: [
                      Positioned(
                          top: Globals.height * (28/812),

                          child: Container(height: Globals.height * (44/812),
                            width: Globals.width * (139/375), child: AutoSizeText(
                              rejectedCount.toString(),
                              style: GoogleFonts.montserrat(
                                  fontSize: 36, color: ColorStyle.text_Color),textAlign: TextAlign.center,
                            ),)),
                      Positioned(
                          bottom: Globals.height * (42/812),
                          left: Globals.width * (28/375),
                          child: Container(height: Globals.height * (44/812),
                            width: Globals.width * (84/375), child: AutoSizeText(
                              'Rejected',
                              style: GoogleFonts.montserrat(
                                  fontSize: 36, color: ColorStyle.text_Color),textAlign: TextAlign.center,
                            ),)),
                    ],
                  ),
              ))),
          Positioned(
              right: Globals.width * (30 / 375),
              top: Globals.height * (577 / 812),
              child: GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(new MaterialPageRoute(builder: (context){
                      return ListClaims('Pending');
                    }));
                  },
                  child:Container(
                width: Globals.width * (139 / 375),
                height: Globals.height * (172 / 812),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        Globals.width * (10 / 375)),
                    color: ColorStyle.in_progress.withOpacity(0.2)),
                child: Stack(
                  children: [
                    Positioned(
                        top: Globals.height * (28/812),

                        child: Container(height: Globals.height * (44/812),
                          width: Globals.width * (139/375), child: AutoSizeText(
                            pendingCount.toString(),
                            style: GoogleFonts.montserrat(
                                fontSize: 36, color: ColorStyle.text_Color),textAlign: TextAlign.center,
                          ),)),
                    Positioned(
                        bottom: Globals.height * (42/812),
                        left: Globals.width * (28/375),
                        child: Container(height: Globals.height * (44/812),
                          width: Globals.width * (84/375), child: AutoSizeText(
                            'In\nProgress',
                            style: GoogleFonts.montserrat(
                                fontSize: 36, color: ColorStyle.text_Color),textAlign: TextAlign.center,
                          ),)),
                  ],
                ),
              ))),
        ],
      ),
    );
  }
}
