import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:facto_user/model/categories.dart';
import 'package:facto_user/util/colors.dart';
import 'package:facto_user/util/globals.dart';
import 'package:facto_user/util/images.dart';
import 'package:facto_user/view/home_screen/home_screen.dart';
import 'package:facto_user/widgets/drawer/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:facto_user/database/firebase.dart';

import 'details_screen.dart';

class Explore extends StatefulWidget {
  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  var feeds;
  var recentFacts;
  var categories = List.filled(0, Categories('', ''), growable: true);
  bool isLoading = true;

  void _openAddEntryDialog(String claim, String url, String url1, String truth,
      BuildContext context) {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new CardDialog(claim, url, url1, truth);
        },
        fullscreenDialog: true));
  }

  initState() {
    super.initState();
    _getData();
  }

  _getData() async {
    feeds = await FirebaseDB.getTrending(Globals.language, context);
    categories = await FirebaseDB.getCategories();
    recentFacts = await FirebaseDB.getRecentChecks(Globals.language);
    setState(() {
      isLoading = false;
    });
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
        key: _scaffoldkey,
        appBar: new AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Colors.white,
          elevation: 15,
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
                    left: 0.0,
                    top: 0.0,
                    bottom: 0.0,
                    child: GestureDetector(
                      child: Container(
                          width: Globals.width * (54 / 375),
                          height: Globals.height * (54 / 812),
                          child: Icon(
                            Icons.settings,
                            color: Colors.black,
                            size: 36,
                          )),
                      onTap: () {
                        _scaffoldkey.currentState.openDrawer();
                      },
                    ),
                  ),
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
                      right: Globals.width * (0 / 375),
                      top: Globals.height * (2 / 812),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: Globals.width * (60 / 375),
                              height: Globals.height * (40 / 812),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                      new MaterialPageRoute(builder: (context) {
                                    return HomeScreen();
                                  }));
                                },
                                child: AutoSizeText(
                                  'Feed',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14),
                                ),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                      new MaterialPageRoute(builder: (context) {
                                    return HomeScreen();
                                  }));
                                },
                                icon: Image.asset(
                                  Images.forward_btn,
                                  // height: Globals.height * (19 / 812),
                                  // width: Globals.width * (18 / 375),
                                  color: Colors.black,
                                )),
                          ])),
                ],
              ),
            )
          ],
        ),
        drawer: MyAppDrawer(),
        body: isLoading
            ? _loadingScreen('Loading Data...')
            : Stack(
                children: [
                  Positioned(
                      top: Globals.getHeight(20),
                      left: Globals.getWidth(25),
                      child: Text(
                        'Recent Fact Checks',
                        style: GoogleFonts.montserrat(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )),
                  Positioned(
                      top: Globals.getHeight(70.0),
                      left: 0.0,
                      child: Container(
                        width: Globals.width,
                        height: Globals.width * (81 / 375),
                        // padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: recentFacts.length == 0
                            ? Center(
                                child: Text(
                                  'No Data',
                                  style: GoogleFonts.montserrat(fontSize: 30),
                                ),
                              )
                            : ListView(
                                scrollDirection: Axis.horizontal,
                                children:
                                    List.generate(recentFacts.length, (index) {
                                  return GestureDetector(
                                    onTap: () {
                                      _openAddEntryDialog(
                                          recentFacts[index].claim,
                                          recentFacts[index].url,
                                          recentFacts[index].url1,
                                          recentFacts[index].truth,
                                          context);
                                    },
                                    child: Container(
                                      width: Globals.width * (81 / 375),
                                      height: Globals.width * (81 / 375),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: Globals.width * 0.02),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              Globals.width * (81 / 375)),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  feeds[index].url),
                                              fit: BoxFit.cover),
                                          border: Border.all(
                                              color: ColorStyle.button_red,
                                              width: 3.0)),
                                    ),
                                  );
                                }),
                              ),
                      )),
                  Positioned(
                      top: Globals.height * 0.2,
                      left: Globals.width * (19 / 375),
                      child: Container(
                        width: Globals.width * (336 / 375),
                        height: Globals.height * (50 / 812),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1.0),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: TextField(
                          // controller: _searchController,
                          onTap: () {
                            Navigator.of(context).pushNamed('/search');
                          },
                          decoration: InputDecoration(
                              hintText: 'Search',
                              hintStyle:
                                  TextStyle(fontSize: 20, color: Colors.grey),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: Globals.getWidth(20),
                                  vertical: Globals.getHeight(15)),
                              border: InputBorder.none,
                              suffixIcon: Icon(
                                Icons.search,
                                color: Colors.black,
                                size: 30,
                              )),
                        ),
                      )),
                  Positioned(
                      top: Globals.height * 0.3,
                      left: Globals.width * (25 / 375),
                      child: Container(
                        width: Globals.width * (80 / 375),
                        child: AutoSizeText(
                          'Trending',
                          style: GoogleFonts.montserrat(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      )),
                  Positioned(
                      top: Globals.height * 0.35,
                      left: 0.0,
                      child: Container(
                        width: Globals.width,
                        height: Globals.height * (184 / 812),
                        // padding:
                        //     EdgeInsets.only(left: Globals.width * (25 / 375)),
                        child: feeds.length == 0
                            ? Text(
                                'No Data',
                                style: GoogleFonts.montserrat(fontSize: 30),
                                textAlign: TextAlign.center,
                              )
                            : ListView(
                                scrollDirection: Axis.horizontal,
                                children: List.generate(feeds.length, (index) {
                                  return GestureDetector(
                                    onTap: () {
                                      _openAddEntryDialog(
                                          feeds[index].claim,
                                          feeds[index].url,
                                          feeds[index].url1,
                                          feeds[index].truth,
                                          context);
                                      // setState(() {
                                      //   if (isDropdownOpened) {
                                      //     floatingDropdown.remove();
                                      //   } else {
                                      //     floatingDropdown = _createFloatingDropdown(
                                      //         feeds[index].claim,
                                      //         feeds[index].url,
                                      //         feeds[index].url1,
                                      //         feeds[index].truth,
                                      //         context);
                                      //     Overlay.of(context)
                                      //         .insert(floatingDropdown);
                                      //   }
                                      //
                                      //   isDropdownOpened = !isDropdownOpened;
                                      // });
                                    },
                                    child: Container(
                                      width: Globals.width * (104 / 375),
                                      height: Globals.height * (184 / 812),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: Globals.width * 0.02),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image:
                                                NetworkImage(feeds[index].url),
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                      )),
                  Positioned(
                      top: Globals.height * 0.6,
                      left: Globals.width * (25 / 375),
                      child: Container(
                        width: Globals.width * (90 / 375),
                        child: AutoSizeText(
                          'Categories',
                          style: GoogleFonts.montserrat(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      )),
                  Positioned(
                      top: Globals.height * 0.65,
                      left: 0.0,
                      child: Container(
                        width: Globals.width,
                        height: Globals.height * 0.18,
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: categories.length == 0
                            ? Text(
                                'No Data',
                                style: GoogleFonts.montserrat(fontSize: 30),
                                textAlign: TextAlign.center,
                              )
                            : ListView(
                                scrollDirection: Axis.horizontal,
                                children:
                                    List.generate(categories.length, (index) {
                                  return OpenContainer(
                                    closedElevation: 0.0,
                                    openElevation: 15.0,
                                    index: index,
                                    transitionType:
                                        ContainerTransitionType.fade,
                                    transitionDuration:
                                        const Duration(milliseconds: 1000),
                                    openBuilder: (context, action) {
                                      return DetailScreen(
                                          categories[index].name,
                                          categories[index].url);
                                    },
                                    closedBuilder: (context, action) {
                                      return !(Globals.selectedIndex == index)
                                          ? Container(
                                              width: Globals.width * 0.25,
                                              height: Globals.height * 0.18,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal:
                                                      Globals.width * 0.02),
                                              decoration: BoxDecoration(
                                                color: ColorStyle.button_red,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                    color: Colors.white),
                                              ),
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Positioned(
                                                    top: Globals.height *
                                                        (34 / 812),
                                                    // left: Globals.width *
                                                    //     (35 / 375),
                                                    child: Container(
                                                        height: Globals.width *
                                                            (48 / 375),
                                                        width: Globals.width *
                                                            (48 / 375),
                                                        child: ImageIcon(
                                                          new NetworkImage(
                                                              categories[index]
                                                                  .url),
                                                          color: Colors.white,
                                                        ),),
                                                  ),
                                                  Positioned(
                                                      top: Globals.height *
                                                          (102 / 812),
                                                      // left: Globals.width *
                                                      //     (0 / 375),
                                                      child: Container(
                                                        height: Globals.height *
                                                            (30 / 812),
                                                        width: Globals.width *
                                                            0.23,
                                                        child: AutoSizeText(
                                                          categories[index]
                                                              .name,
                                                          style: GoogleFonts
                                                              .montserrat(
                                                                  fontSize: 20,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                          textAlign:
                                                              TextAlign.center,
                                                          overflow: TextOverflow.visible,
                                                        ),
                                                      ))
                                                ],
                                              ))
                                          : Container(
                                              width: Globals.width * 0.25,
                                              height: Globals.height * 0.18,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal:
                                                      Globals.width * 0.02),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                    color:
                                                        ColorStyle.button_red),
                                              ),
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Positioned(
                                                    top: Globals.height *
                                                        (34 / 812),
                                                    // left: Globals.width *
                                                    //     (35 / 375),
                                                    child: Container(
                                                      height: Globals.width *
                                                          (48 / 375),
                                                      width: Globals.width *
                                                          (48 / 375),
                                                      child: ImageIcon(
                                                        new NetworkImage(
                                                            categories[index]
                                                                .url),
                                                        color: ColorStyle
                                                            .button_red,
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                      top: Globals.height *
                                                          (102 / 812),
                                                      // left: Globals.width *
                                                      //     (0 / 375),
                                                      child: Container(
                                                        height: Globals.height *
                                                            (30 / 812),
                                                        width: Globals.width *
                                                            0.23,
                                                        child: AutoSizeText(
                                                          categories[index]
                                                              .name,
                                                          style: GoogleFonts
                                                              .montserrat(
                                                                  fontSize: 20,
                                                                  color: ColorStyle
                                                                      .button_red,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ))
                                                ],
                                              ));
                                    },
                                  );
                                }),
                              ),
                      )),
                ],
              ),
      ),
      top: true,
    );
  }
}

class CardDialog extends StatefulWidget {
  final String claim;
  final String url;
  final String url1;
  final String truth;

  CardDialog(this.claim, this.url, this.url1, this.truth);

  @override
  CardDialogState createState() => new CardDialogState();
}

class CardDialogState extends State<CardDialog> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 15,
        actions: [
          Container(
            width: Globals.width - 50,
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
                  left: Globals.width * (105 / 375),
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
              ],
            ),
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(top: Globals.height * 0.005),
        height: Globals.height * 0.85,
        width: Globals.width,
        child: Stack(
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
                  child: AutoSizeText(this.widget.claim,
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
                      image: NetworkImage(this.widget.url), fit: BoxFit.cover),
                ),
              ),
            ),
            Positioned(
              top: Globals.height * 0.51,
              left: Globals.width * 0.06,
              child: Container(
                height: Globals.height * 0.15,
                width: Globals.width * 0.8,
                child: AutoSizeText(
                    'Source: ' + Uri.parse(this.widget.url1.toString()).host),
              ),
            ),
            Positioned(
              top: Globals.height * 0.6,
              left: Globals.width * 0.05,
              child: Container(
                padding: EdgeInsets.only(
                    top: Globals.getHeight(22),
                    left: 10,
                    right: 10.0,
                    bottom: 10.0),
                height: Globals.height * 0.17,
                width: Globals.width * 0.9,
                child: Center(
                  child: AutoSizeText(this.widget.truth,
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
              top: Globals.height * 0.58,
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
      ),
    );
  }
}
