import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:facto_user/database/firebase.dart';
import 'package:facto_user/model/ad.dart';
import 'package:facto_user/model/feed.dart';
import 'package:facto_user/util/colors.dart';
import 'package:facto_user/util/globals.dart';
import 'package:facto_user/util/images.dart';
import 'package:facto_user/view/dashboard/details.dart';
import 'package:facto_user/view/explore/explore.dart';
import 'package:facto_user/view/home_screen/home_screen.dart';
import 'package:facto_user/widgets/drawer/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swipedetector/swipedetector.dart';
import 'package:toast/toast.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DashBoard extends StatefulWidget {
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  int index = 0;
  var widgets = [];
  PageController _pageController;
  Duration pageTurnDuration = Duration(milliseconds: 500);
  Curve pageTurnCurve = Curves.ease;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLoading = true;
  var locations = ['India', 'Worldwide'];
  var feeds = List.filled(0, Feed('', '', '', '', ''), growable: true);
  var ads = List.filled(0, Ad('', ''), growable: true);
  String url = 'f';
  String description = 'f';

  @override
  void initState() {
    super.initState();
    _getData();

    _pageController = PageController();
  }

  _getData() async {
    // await FirebaseDB.feedCloner();
    feeds =
        await FirebaseDB.getFeeds(Globals.language, context).whenComplete(() async {
     ads = await FirebaseDB.getAd(context);
    });
    int lowerLimit = feeds.length ~/ 5;
    print(feeds.length);
    print(lowerLimit);
    Random r = new Random();
    var newFeeds = List.filled(0, Feed('', '', '', '', ''), growable: true);
    for(int i=0;i<(lowerLimit * 5);i+=5){
      newFeeds = feeds.sublist(i,i+5);
      widgets.addAll(List.generate(newFeeds.length, (index) {
        return Container(
          margin: EdgeInsets.only(top: Globals.height * 0.005),
          height: Globals.height * 0.5,
          width: Globals.width,
          child: Globals.feedType
              ? Stack(
            children: [
              Positioned(
                top: Globals.height * 0.05,
                left: Globals.width * 0.05,
                child: Container(
                  padding: EdgeInsets.only(
                      top: Globals.getHeight(22),
                      left: 10,
                      right: 10.0,
                      bottom: 10.0),
                  height: Globals.height * 0.165,
                  width: Globals.width * 0.9,
                  decoration: BoxDecoration(
                      color: Color(0xFFEDF2F4),
                      border: Border.all(color: Colors.red, width: 1.0),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40.0),
                          bottomRight: Radius.circular(40.0))),
                  child: Center(
                    child: AutoSizeText(newFeeds[index].claim,
                        style: GoogleFonts.montserrat(
                          fontSize: 22,
                          fontWeight: FontWeight.w300,
                        )),
                  ),
                ),
              ),
              Positioned(
                top: Globals.height * 0.25,
                left: Globals.width * 0.05,
                child: Container(
                  height: Globals.height * 0.25,
                  width: Globals.width * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        bottomRight: Radius.circular(40.0)),
                    image: DecorationImage(
                        image: NetworkImage(newFeeds[index].url),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
              Positioned(
                top: Globals.height * 0.51,
                left: Globals.width * 0.06,
                child: Container(
                  height: Globals.height * 0.15,
                  width: Globals.width * 0.8,
                  child: AutoSizeText('Source: ' +
                      Uri.parse(newFeeds[index].url1.toString()).host),
                ),
              ),
              Positioned(
                top: Globals.height * 0.57,
                left: Globals.width * 0.05,
                child: Container(
                  padding: EdgeInsets.only(
                      top: Globals.getHeight(22),
                      left: 10,
                      right: 10.0,
                      bottom: 10.0),
                  height: Globals.height * 0.2,
                  width: Globals.width * 0.9,
                  child: Center(
                    child: AutoSizeText(newFeeds[index].truth,
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w300, fontSize: 16)),
                  ),
                  decoration: BoxDecoration(
                      color: Color(0xFFEDF2F4),
                      border: Border.all(color: Colors.green, width: 1.0),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40.0),
                          bottomRight: Radius.circular(40.0))),
                ),
              ),
              Positioned(
                top: Globals.height * 0.03,
                left: Globals.width * 0.2,
                child: Container(
                  width: Globals.width * 0.22,
                  height: Globals.getHeight(40),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Color(0xFFC40010)),
                  child: Center(
                    child: Text(
                      'Claim',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: Globals.height * 0.55,
                right: Globals.width * 0.17,
                child: Container(
                  width: Globals.width * 0.22,
                  height: Globals.getHeight(40),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Color(0xFF34A853)),
                  child: Center(
                    child: Text(
                      'Truth',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ),
              ),
            ],
          )
              : Stack(
            children: [
              Positioned(
                top: Globals.height * 0.05,
                left: Globals.width * 0.1,
                child: Container(
                  padding: EdgeInsets.only(
                      top: Globals.getHeight(30),
                      left: 10,
                      right: 10.0,
                      bottom: 10.0),
                  height: Globals.height * 0.18,
                  width: Globals.width * 0.8,
                  decoration: BoxDecoration(
                      color: Color(0xFFEDF2F4),
                      border: Border.all(color: Colors.red, width: 1.0),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40.0),
                          bottomRight: Radius.circular(40.0))),
                  child: Center(
                    child: AutoSizeText(newFeeds[index].claim,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22)),
                  ),
                ),
              ),
              Positioned(
                top: Globals.height * 0.3,
                left: Globals.width * 0.1,
                child: Container(
                  height: Globals.height * 0.25,
                  width: Globals.width * 0.8,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        bottomRight: Radius.circular(40.0)),
                  ),
                  child: YoutubePlayer(
                    controller: YoutubePlayerController(
                      initialVideoId: newFeeds[index].urlVideo.substring(
                        32,
                      ),
                      flags: YoutubePlayerFlags(
                        autoPlay: false,
                        mute: false,
                      ),
                    ),
                    showVideoProgressIndicator: false,
                    bottomActions: [],

                  ),
                ),
              ),
              Positioned(
                top: Globals.height * 0.62,
                left: Globals.width * 0.1,
                child: Container(
                  padding: EdgeInsets.only(
                      top: Globals.getHeight(30),
                      left: 10,
                      right: 10.0,
                      bottom: 10.0),
                  height: Globals.height * 0.15,
                  width: Globals.width * 0.8,
                  child: Center(
                    child: AutoSizeText(newFeeds[index].truth,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  decoration: BoxDecoration(
                      color: Color(0xFFEDF2F4),
                      border: Border.all(color: Colors.green, width: 1.0),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40.0),
                          bottomRight: Radius.circular(40.0))),
                ),
              ),
              Positioned(
                top: Globals.height * 0.03,
                left: Globals.width * 0.2,
                child: Container(
                  width: Globals.width * 0.3,
                  height: Globals.getHeight(50),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Color(0xFFC40010)),
                  child: Center(
                    child: Text(
                      'Claim',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: Globals.height * 0.60,
                right: Globals.width * 0.2,
                child: Container(
                  width: Globals.width * 0.3,
                  height: Globals.getHeight(50),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Color(0xFF34A853)),
                  child: Center(
                    child: Text(
                      'Truth',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
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
              ]),
        );
      }));
      newFeeds.addAll(feeds.sublist(i,i+5));
      int k = r.nextInt(ads.length - 1);
      setState(() {
        Ad a = ads[k];
        url = a.url;
        description = a.description;
      });
      widgets.add(_adPage());
    }
    newFeeds = feeds.sublist(5*lowerLimit,feeds.length);
    widgets.addAll(List.generate(newFeeds.length, (index) {
      return Container(
        margin: EdgeInsets.only(top: Globals.height * 0.005),
        height: Globals.height * 0.5,
        width: Globals.width,
        child: Globals.feedType
            ? Stack(
          children: [
            Positioned(
              top: Globals.height * 0.05,
              left: Globals.width * 0.05,
              child: Container(
                padding: EdgeInsets.only(
                    top: Globals.getHeight(22),
                    left: 10,
                    right: 10.0,
                    bottom: 10.0),
                height: Globals.height * 0.165,
                width: Globals.width * 0.9,
                decoration: BoxDecoration(
                    color: Color(0xFFEDF2F4),
                    border: Border.all(color: Colors.red, width: 1.0),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        bottomRight: Radius.circular(40.0))),
                child: Center(
                  child: AutoSizeText(newFeeds[index].claim,
                      style: GoogleFonts.montserrat(
                        fontSize: 22,
                        fontWeight: FontWeight.w300,
                      )),
                ),
              ),
            ),
            Positioned(
              top: Globals.height * 0.25,
              left: Globals.width * 0.05,
              child: Container(
                height: Globals.height * 0.25,
                width: Globals.width * 0.9,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      bottomRight: Radius.circular(40.0)),
                  image: DecorationImage(
                      image: NetworkImage(newFeeds[index].url),
                      fit: BoxFit.cover),
                ),
              ),
            ),
            Positioned(
              top: Globals.height * 0.51,
              left: Globals.width * 0.06,
              child: Container(
                height: Globals.height * 0.15,
                width: Globals.width * 0.8,
                child: AutoSizeText('Source: ' +
                    Uri.parse(newFeeds[index].url1.toString()).host),
              ),
            ),
            Positioned(
              top: Globals.height * 0.57,
              left: Globals.width * 0.05,
              child: Container(
                padding: EdgeInsets.only(
                    top: Globals.getHeight(22),
                    left: 10,
                    right: 10.0,
                    bottom: 10.0),
                height: Globals.height * 0.2,
                width: Globals.width * 0.9,
                child: Center(
                  child: AutoSizeText(newFeeds[index].truth,
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w300, fontSize: 16)),
                ),
                decoration: BoxDecoration(
                    color: Color(0xFFEDF2F4),
                    border: Border.all(color: Colors.green, width: 1.0),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        bottomRight: Radius.circular(40.0))),
              ),
            ),
            Positioned(
              top: Globals.height * 0.03,
              left: Globals.width * 0.2,
              child: Container(
                width: Globals.width * 0.22,
                height: Globals.getHeight(40),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Color(0xFFC40010)),
                child: Center(
                  child: Text(
                    'Claim',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
            ),
            Positioned(
              top: Globals.height * 0.55,
              right: Globals.width * 0.17,
              child: Container(
                width: Globals.width * 0.22,
                height: Globals.getHeight(40),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Color(0xFF34A853)),
                child: Center(
                  child: Text(
                    'Truth',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
            ),
          ],
        )
            : Stack(
          children: [
            Positioned(
              top: Globals.height * 0.05,
              left: Globals.width * 0.1,
              child: Container(
                padding: EdgeInsets.only(
                    top: Globals.getHeight(30),
                    left: 10,
                    right: 10.0,
                    bottom: 10.0),
                height: Globals.height * 0.18,
                width: Globals.width * 0.8,
                decoration: BoxDecoration(
                    color: Color(0xFFEDF2F4),
                    border: Border.all(color: Colors.red, width: 1.0),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        bottomRight: Radius.circular(40.0))),
                child: Center(
                  child: AutoSizeText(newFeeds[index].claim,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 22)),
                ),
              ),
            ),
            Positioned(
              top: Globals.height * 0.3,
              left: Globals.width * 0.1,
              child: Container(
                height: Globals.height * 0.25,
                width: Globals.width * 0.8,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      bottomRight: Radius.circular(40.0)),
                ),
                child: YoutubePlayer(
                  controller: YoutubePlayerController(
                    initialVideoId: newFeeds[index].urlVideo.substring(
                      32,
                    ),
                    flags: YoutubePlayerFlags(
                      autoPlay: false,
                      mute: false,
                    ),
                  ),
                  showVideoProgressIndicator: false,
                  bottomActions: [],

                ),
              ),
            ),
            Positioned(
              top: Globals.height * 0.62,
              left: Globals.width * 0.1,
              child: Container(
                padding: EdgeInsets.only(
                    top: Globals.getHeight(30),
                    left: 10,
                    right: 10.0,
                    bottom: 10.0),
                height: Globals.height * 0.15,
                width: Globals.width * 0.8,
                child: Center(
                  child: AutoSizeText(newFeeds[index].truth,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                decoration: BoxDecoration(
                    color: Color(0xFFEDF2F4),
                    border: Border.all(color: Colors.green, width: 1.0),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        bottomRight: Radius.circular(40.0))),
              ),
            ),
            Positioned(
              top: Globals.height * 0.03,
              left: Globals.width * 0.2,
              child: Container(
                width: Globals.width * 0.3,
                height: Globals.getHeight(50),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Color(0xFFC40010)),
                child: Center(
                  child: Text(
                    'Claim',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
            ),
            Positioned(
              top: Globals.height * 0.60,
              right: Globals.width * 0.2,
              child: Container(
                width: Globals.width * 0.3,
                height: Globals.getHeight(50),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Color(0xFF34A853)),
                child: Center(
                  child: Text(
                    'Truth',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
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
            ]),
      );
    }));
    print('widgets: ' + widgets.length.toString());

    print(feeds.length);
    setState(() {
      isLoading = false;
    });
  }

  void _goForward() {
    _pageController.nextPage(duration: pageTurnDuration, curve: pageTurnCurve);
  }

  void _goBack() {
    _pageController.previousPage(
        duration: pageTurnDuration, curve: pageTurnCurve);
  }
  Future<void> _loadingDialog(String value) {
    return showDialog<void>(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
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
                ))));
  }

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            drawerScrimColor: Colors.white.withOpacity(0.77),
            drawer: Container(
              width: Globals.width * 0.65,
              child: MyAppDrawer(),
            ),
            appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 10,
              foregroundColor: Colors.transparent,
              backgroundColor: Colors.transparent,
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
                        left: Globals.width * (0 / 375),
                        top: Globals.height * (2 / 812),
                        child: Container(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.of(context).pushReplacement(
                                          new MaterialPageRoute(
                                              builder: (context) {
                                        return Explore();
                                      }));
                                    },
                                    icon: Image.asset(
                                      Images.back_btn,
                                      height: Globals.height * (19 / 812),
                                      width: Globals.width * (13 / 375),
                                      color: Colors.black,
                                    )),
                                Container(
                                  height: Globals.height * (40 / 812),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pushReplacement(
                                          new MaterialPageRoute(
                                              builder: (context) {
                                        return Explore();
                                      }));
                                    },
                                    child: AutoSizeText(
                                      'Explore',maxLines: 1,
                                      maxFontSize: 14,minFontSize: 8,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                )
                              ]),
                        ),
                      ),
                      // Positioned(
                      //     left: Globals.width * (30 / 375),
                      //     top: Globals.height * (7 / 812),
                      //     child: ),
                      Positioned(
                        left: Globals.width * (137 / 375),
                        top: 10,
                        child: Container(
                          width: Globals.width * (100 / 375),
                          height: Globals.height * (39 / 812),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(Images.logo),
                                  fit: BoxFit.contain)),
                        ),
                      ),
                      Positioned(
                        left: Globals.width * (270 / 375),
                        top: 5.0,
                        child: PopupMenuButton<String>(
                          icon: Globals.location == 'India'?new Image.asset(Images.india):new Image.asset(Images.earth),
                          onSelected: (String result) {
                            print(result);
                          if(Globals.location != result){
                            setState(() {
                              Globals.location = result;
                            });
                            print(Globals.location);
                            Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context){return HomeScreen();}));
                          }
                          },
                          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                             PopupMenuItem<String>(
                              value: 'India',
                              child:
                                  new Image.asset(Images.india,width: 30,height: 30,),
                            ),
                             PopupMenuItem<String>(
                              value: 'WorldWide',
                              child:
                                  new Image.asset(Images.earth,width: 30,height: 30),

                            ),
                          ],
                        ),
                      ),
                      Positioned(
                          right: Globals.width * (10 / 375),
                          top: Globals.height * (2 / 812),
                          child: Container(
                            child:
                                  IconButton(
                                      onPressed: () {
                                        Globals.category = null;
                                        Navigator.of(context).pushReplacement(
                                            new MaterialPageRoute(
                                                builder: (context) {
                                                  return HomeScreen();
                                                }));
                                      },
                                      icon: Image.asset(
                                        Images.refresh_btn,
                                        height: Globals.height * (19 / 812),
                                        width: Globals.width * (18 / 375),
                                        color: Colors.black,
                                      )),

                          )),
                      // Positioned(
                      //     right: Globals.width * (8 / 375),
                      //     top: Globals.height * (9 / 812),
                      //     child: xxx),
                    ],
                  ),
                ),
              ],
            ),
            body: isLoading
                ? _loadingScreen('Getting Data...')
                : feeds.length == 0
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              Images.no_data,
                              height: 250,
                              width: 250,
                            ),
                            Text(
                              'No Data',
                              style: GoogleFonts.montserrat(fontSize: 30),
                            )
                          ],
                        ),
                      )
                    : SwipeDetector(
                        onSwipeUp: () async {
                          try {
                            print('Feed is: ' + feeds.length.toString());
                            if (index == (widgets.length - 1)) {
                              Toast.show(
                                  'No more new posts available', context);
                            } else {
                              setState(() {
                                  index += 1;
                                  print('currIndex' + index.toString());
                                });
                              if(index%5!=0){
                                Globals.currentFeed = feeds[index - (index~/5)];
                              }
                                _goForward();
                            }
                          } catch (e) {
                            Toast.show(
                                'No more posts in this category', context);
                          }
                        },
                        onSwipeDown: () {
                          print('Index is: ' + index.toString());
                          setState(() {
                            if (index == 0) {
                              Navigator.of(context).pushReplacement(
                                  new MaterialPageRoute(builder: (context) {
                                return HomeScreen();
                              }));
                            } else if (index > 0) {
                              index -= 1;
                            }
                          });
                          if(index%5!=0){
                            Globals.currentFeed = feeds[index - (index~/5)];
                          }
                          _goBack();
                        },
                        onSwipeLeft: () async {
                          if(index%5!=0){
                            await FirebaseDB.updateClicks(feeds[index - (index~/5)].docId);
                            Navigator.push(context,
                                new MaterialPageRoute(builder: (context) {
                                  return Details(feeds[index - (index~/5)].url1);
                                }));
                          }
                        },
                        child: Container(
                            width: Globals.width,
                            height: Globals.height * 0.85,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
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
                                ]),
                            child: PageView.builder(
                                scrollDirection: Axis.vertical,
                                controller: _pageController,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return widgets[index];
                                })),
                      )));
  }

  Widget _adPage() {
    return Stack(
      children: [
        Positioned(
            top: Globals.getHeight(20),
            child: Container(
              width: Globals.width,
              child: AutoSizeText(
                'Ad',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            )),
        Positioned(
          top: Globals.height * 0.1,
          left: Globals.width * 0.1,
          child: Material(
            elevation: 20,
            child: Container(
              height: Globals.height * 0.3,
              width: Globals.width * 0.8,
              decoration: BoxDecoration(
                color: Colors.grey,
                border: Border.all(color: Colors.black),
                image: DecorationImage(
                    image: NetworkImage(url), fit: BoxFit.cover),
              ),
            ),
          ),
        ),
        Positioned(
          top: Globals.height * 0.4,
          left: Globals.width * 0.1,
          child: Container(
            padding: EdgeInsets.all(10.0),
            height: Globals.height * 0.4,
            width: Globals.width * 0.8,
            child: Center(
              child: AutoSizeText(
                description,
                style: TextStyle(
                  fontSize: 18,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
