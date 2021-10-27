import 'package:auto_size_text/auto_size_text.dart';
import 'package:facto_user/services/auth/auth.dart';
import 'package:facto_user/util/colors.dart';
import 'package:facto_user/util/globals.dart';
import 'package:facto_user/util/images.dart';
import 'package:facto_user/view/about_us/about_us.dart';
import 'package:facto_user/view/auth/sign_in.dart';
import 'package:facto_user/view/dashboard/dashboard.dart';
import 'package:facto_user/view/edit_profile/edit_profile.dart';
import 'package:facto_user/view/file_claim/file_claim.dart';
import 'package:facto_user/view/home_screen/home_screen.dart';
import 'package:facto_user/view/user_profile/user_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share/share.dart';
import 'package:toast/toast.dart';

class MyAppDrawer extends StatefulWidget {
  @override
  _MyAppDrawerState createState() => _MyAppDrawerState();
}

class _MyAppDrawerState extends State<MyAppDrawer> {
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Drawer(
        child: Stack(
          children: [
            Positioned(
                top: Globals.getHeight(10),
                left: Globals.getWidth(10),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    size: 48,
                    color: ColorStyle.text_Color,
                  ),
                )),
            Positioned(
                top: Globals.height * 0.1167,
                left: Globals.width * 0.205,
                child: Container(
                  height: Globals.height * (100 / 812),
                  width: Globals.width * 0.2666667,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          Globals.width * 0.2666667 * 0.36),
                      image: DecorationImage(
                          image: Globals.user==null?AssetImage(Images.user,):NetworkImage(Globals.user.dp),
                          fit: BoxFit.cover)),
                  child: TextButton(
                    onPressed: () {
                      if(Globals.user != null){
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return UserProfile();
                        }));
                      }
                      else{
                        Toast.show('Please sign in to use this feature', context);
                      }
                    },
                  ),
                )),
            Positioned(
                top: Globals.height * 0.254,
                left: Globals.width * 0.1786,
                child: Container(
                  width: Globals.width * 0.32,
                  height: Globals.height * 0.029,
                  child: AutoSizeText(
                    Globals.user==null?'Facto':Globals.user.name,
                    style: GoogleFonts.montserrat(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                )),
            Positioned(
                top: Globals.height * (236 / 812),
                left: Globals.width * (78 / 375),
                child: Container(
                  height: Globals.height * (30 / 812),
                  width: Globals.width * (92 / 375),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        Globals.width * (78 / 375) * (8 / 78)),
                    border: Border.all(color: ColorStyle.button_red),
                  ),
                  child: TextButton(
                    onPressed: () {
                      if(Globals.user != null){
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return EditProfile();
                        }));
                      }
                      else{
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return SignIn();
                        }));
                      }
                    },
                    child: Text(
                      'Edit Profile',
                      style: GoogleFonts.montserrat(
                          color: ColorStyle.text_Color, fontSize: 12),
                    ),
                  ),
                )),
            Positioned(
                top: Globals.height * (268 / 812),
                left: Globals.width * 0.05,
                child: Container(
                    width: Globals.width * (129 / 375),
                    height: Globals.height * (50 / 812),
                    child: GestureDetector(
                      onTap: () {
                        if(Globals.user != null){
                          Navigator.push(context, MaterialPageRoute(builder: (_) {
                            return FileClaim();
                          }));
                        }
                        else{
                          Navigator.push(context, MaterialPageRoute(builder: (_) {
                            return SignIn();
                          }));
                        }
                      },
                      child: AutoSizeText(
                        'Request\nFact Check',
                        style: GoogleFonts.montserrat(
                            fontSize: 24, color: ColorStyle.text_Color),
                      ),
                    ))),
            Positioned(
                top: Globals.height * (319 / 812),
                left: Globals.width * 0.05,
                child: Container(
                    width: Globals.width * 0.55,
                    child: Divider(
                      color: Colors.black,
                      thickness: 1.0,
                    ))),
            Positioned(
                top: Globals.height * (342 / 812),
                left: Globals.width * 0.05,
                child: Container(
                    width: Globals.width * 0.55,
                    height: Globals.height * 0.05,
                    child: Stack(
                      children: [
                        Container(
                          width: Globals.width * (129 / 375),
                          height: Globals.height * 0.07,
                          child: AutoSizeText(
                            'Language\n${Globals.language ? 'English' : 'Hindi'}',
                            style: GoogleFonts.montserrat(
                                fontSize: 24, color: ColorStyle.text_Color),
                          ),
                        ),
                        Positioned(
                          child: Switch(
                              value: Globals.language,
                              activeColor: ColorStyle.text_Color,
                              onChanged: (value) {
                                setState(() {
                                  Globals.language = value;
                                });
                                Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context){return HomeScreen();}));
                              }),
                          right: 0.0,
                        )
                      ],
                    ))),
            Positioned(
                top: Globals.height * 0.48,
                left: Globals.width * 0.05,
                child: Container(
                    width: Globals.width * 0.55,
                    child: Divider(
                      color: Colors.black,
                      thickness: 1.0,
                    ))),
            Positioned(
                top: Globals.height * 0.5,
                left: Globals.width * 0.05,
                child: Container(
                    width: Globals.width * (129 / 375),
                    height: Globals.height * (70 / 812),
                    child: GestureDetector(
                      onTap: () {
                        Share.share(
                            'Check out this new amazing app: \n\n https://play.google.com/store/apps/details?id=com.codingdevs.facto_user');
                      },
                      child: AutoSizeText(
                        'Invite',
                        style: GoogleFonts.montserrat(
                            fontSize: 24, color: ColorStyle.text_Color),
                      ),
                    ))),
            Positioned(
                top: Globals.height * 0.55,
                left: Globals.width * 0.05,
                child: Container(
                    width: Globals.width * 0.55,
                    child: Divider(
                      color: Colors.black,
                      thickness: 1.0,
                    ))),
            Positioned(
                top: Globals.height * 0.58,
                left: Globals.width * 0.05,
                child: Container(
                    width: Globals.width * (129 / 375),
                    height: Globals.height * (50 / 812),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return AboutUs();
                        }));
                      },
                      child: AutoSizeText(
                        'About Us',
                        style: GoogleFonts.montserrat(
                            fontSize: 24, color: ColorStyle.text_Color),
                      ),
                    ))),
            Positioned(
                top: Globals.height * 0.63,
                left: Globals.width * 0.05,
                child: Container(
                    width: Globals.width * 0.55,
                    child: Divider(
                      color: Colors.black,
                      thickness: 1.0,
                    ))),
            Positioned(
              top: Globals.height * (635 / 812),
              left: Globals.width * 0.0725,
              child: Container(
                width: Globals.width * 0.45,
                height: Globals.height * (55.16 / 812),
                decoration: BoxDecoration(
                    color: ColorStyle.button_red,
                    borderRadius: BorderRadius.circular(
                        Globals.width * 0.45 * (28 / 187))),
                child: TextButton(
                  onPressed: Globals.user == null
                      ? () {
                          Navigator.of(context).pushReplacement(
                              new MaterialPageRoute(builder: (context) {
                            return SignIn();
                          }));
                        }
                      : () async {
                    await googleSignIn.signOut();
                    await auth.signOut();
                          setState(() {
                            auth = null;
                            Globals.user = null;
                          });

                          Navigator.of(context).pushReplacement(
                              new MaterialPageRoute(builder: (context) {
                            return HomeScreen();
                          }));
                        },
                  child: Text(
                    Globals.user == null ? 'Sign In' : 'Log Out',
                    style: GoogleFonts.montserrat(
                        fontSize: 20.0, color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(30), bottomRight: Radius.circular(30)),
    );
  }
}
