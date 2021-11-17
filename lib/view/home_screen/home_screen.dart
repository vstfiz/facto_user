import 'package:facto_user/util/colors.dart';
import 'package:facto_user/util/globals.dart';
import 'package:facto_user/util/images.dart';
import 'package:facto_user/view/auth/sign_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  GlobalKey _btnKey = new GlobalKey();
  bool _btnHide = true;

  List<BottomNavigationBarItem> tabs = [
    new BottomNavigationBarItem(
        icon: new Image.asset(
          Images.bar_search_icon,
          height: 30,
          width: 30,
        ),
        label: 'Search'),
    new BottomNavigationBarItem(
        icon: new Image.asset(
          Images.dashboard_btn,
          height: 40,
          width: 40,
        ),
        label: 'Image Feed'),
    Globals.feedType
        ? new BottomNavigationBarItem(
            icon: new Image.asset(
              Images.bar_video_feed_icon,
              height: 30,
              width: 30,
            ),
            label: 'Image Feed')
        : new BottomNavigationBarItem(
            icon: new Image.asset(
              Images.bar_images_feed_icon,
              height: 30,
              width: 30,
            ),
            label: 'Video Feed'),
    new BottomNavigationBarItem(
        icon: new Image.asset(
          Images.user_btn,
          height: 30,
          width: 30,
        ),
        label: 'Video Feed')
  ];

  Future<void> _exitDialog() {
    return showDialog<void>(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            backgroundColor: Colors.white,
            content: Text('Do you want to exit ?',style: TextStyle(fontSize: 22)),
          actions: [
            TextButton(onPressed: (){
              SystemNavigator.pop();
            }, child: Text('Yes',style: TextStyle(fontSize: 18,color: Colors.orange)),),
            TextButton(onPressed: (){
              Navigator.pop(context);
            }, child: Text('No',style: TextStyle(fontSize: 18,color: Colors.orange))),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      body: GestureDetector(
        onTap: () {
          setState(() {
            _btnHide = !_btnHide;
          });
        },
        child: PageView.builder(
          controller: Globals.pageController,
          itemCount: Globals.screens.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Globals.screens[index];
          },
        ),
      ),
      bottomNavigationBar: _btnHide
          ? ClipRRect(
        child: BottomNavigationBar(
          items: tabs,
          key: _btnKey,
          elevation: 20,
          currentIndex: Globals.currentTab,
          onTap: (index) {
            print(index);
            if (index == 0) {
              setState(() {
                Globals.currentTab = 0;
              });
              Globals.pageController.jumpToPage(0);
            } else if (index == 1) {
              if (Globals.user != null) {
                setState(() {
                  Globals.currentTab = 1;
                });
                Globals.pageController.jumpToPage(1);
              } else {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return SignIn();
                }));
              }
            } else if (index == 2) {
              print(Globals.feedType);
              if(Globals.currentTab == 2){
                setState(() {
                  Globals.feedType = !Globals.feedType;
                });
                Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context){return HomeScreen();}));
              }
              else{
                setState(() {
                  Globals.currentTab = 2;
                });
                Globals.pageController.jumpToPage(2);
              }

            } else if (index == 3) {
              String shareMessage;
              if(Globals.feedType){
                shareMessage = Globals.currentFeed.claim.length > 250
                    ? Globals.currentFeed.claim.substring(0, 250) +
                    "...\n\nTo read more, download: \n\n https://play.google.com/store/apps/details?id=com.codingdevs.facto_user"
                    : Globals.currentFeed.claim +
                    "\n\nTo read more, download: \n\n https://play.google.com/store/apps/details?id=com.codingdevs.facto_user";
              }
              else{
                shareMessage = Globals.currentFeed.claim.length > 250
                    ? Globals.currentFeed.claim.substring(0, 250) +
                    "...\n\nTo read more, download: \n\n https://play.google.com/store/apps/details?id=com.codingdevs.facto_user"
                    : Globals.currentFeed.claim +
                    "\n\nTo read more, download: \n\n https://play.google.com/store/apps/details?id=com.codingdevs.facto_user";

              }
              Share.share(shareMessage);
            }
          },
          type: BottomNavigationBarType.shifting,
          backgroundColor: Color(0xFFEDF2F4).withOpacity(0.1),
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      )
          : SizedBox(),
    ), onWillPop: (
    ){
      _exitDialog();
      return Future.value(false);
    });
  }
}
