import 'package:auto_size_text/auto_size_text.dart';
import 'package:facto_user/model/user.dart';
import 'package:facto_user/services/auth/auth.dart';
import 'package:facto_user/util/colors.dart';
import 'package:facto_user/util/globals.dart';
import 'package:facto_user/util/images.dart';
import 'package:facto_user/view/auth/otp.dart';
import 'package:facto_user/view/edit_profile/edit_profile.dart';
import 'package:facto_user/view/home_screen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart' as fAuth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:facto_user/database/firebase.dart' as fdb;

import 'package:google_fonts/google_fonts.dart';
import 'package:toast/toast.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController _phoneController = new TextEditingController();
  String phoneError;
  FocusNode _phoneFocus = new FocusNode();

  Future<void> _loadingDialog(String value) {
    return showDialog<void>(
        barrierDismissible: false,
        context: context,
        builder: (context) =>
            AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                backgroundColor: Colors.white,
                content: Container(
                    height: 60,
                    child: Center(
                      child: Row(
                        children: <Widget>[
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                ColorStyle.button_red),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            value,
                            style: TextStyle(
                                fontFamily: "Livvic",
                                fontSize: 23,
                                letterSpacing: 1),
                          )
                        ],
                      ),
                    )
                )
            )
    );
  }


  Widget _loadingScreen(String value) {
    return AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        backgroundColor: Colors.white,
        content: Container(
            height: 60,
            child: Center(
              child: Row(
                children: <Widget>[
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    value,
                    style: TextStyle(
                        fontFamily: "Livvic", fontSize: 23, letterSpacing: 1),
                  )
                ],
              ),
            )));
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
                height: Globals.height * 0.5,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(Images.upper_clipper),
                        fit: BoxFit.cover)),
              )),
          Positioned(
            child: IconButton(
              onPressed: (){
                Navigator.of(context).push(
                    new MaterialPageRoute(builder: (context) {
                      return HomeScreen();
                    }));
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
            bottom: 0.0,
            left: 0.0,
            child: Container(
              width: Globals.width,
              height: Globals.height * 0.5,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(Images.lower_clipper),
                      fit: BoxFit.cover)),
            ),
          ),
          Positioned(
              top: Globals.height * 0.15,
              left: Globals.width * 0.15,
              child: Container(
                width: Globals.width * 0.7,
                height: Globals.getHeight(120),
                decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage(Images.logo))),
              )),
          Positioned(
              top: Globals.height * 0.4,
              left: Globals.width * 0.15,
              child: Container(
                  height: Globals.height * 0.25,
                  width: Globals.width * 0.7,
                  child: TextField(
                    controller: _phoneController,
                    focusNode: _phoneFocus,
                    keyboardType: TextInputType.phone,
                    onChanged: (value) {
                      RegExp _phonePattern = new RegExp(r'^[1-9]{1}[0-9]{9}$');
                      if (!_phonePattern.hasMatch(value)) {
                        setState(() {
                          phoneError = 'Enter a valid Phone Number';
                        });
                      }
                      else {
                        setState(() {
                          phoneError = null;
                        });
                        _phoneFocus.unfocus();
                      }
                    },
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        errorText: phoneError,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 15.0),
                        suffixIcon: new Image.asset(Images.online_status),
                        hintText: 'Phone Number'
                    ),

                  )
              )),
          Positioned(
              top: Globals.height * 0.5,
              left: Globals.width * 0.15,
              child: Container(
                  height: Globals.height * 0.06,
                  width: Globals.width * 0.7,
                  decoration: BoxDecoration(
                      color: ColorStyle.button_red,
                      borderRadius: BorderRadius.circular(30.0)
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          new MaterialPageRoute(builder: (context) {
                            return OTP(_phoneController.text);
                          }));
                    },
                    child: Row(
                      children: [

                        Container(
                          margin: EdgeInsets.only(left: Globals.width * 0.1),
                          width: Globals.width * 0.35,
                          child: AutoSizeText(
                            'Sign In',style: GoogleFonts.montserrat(
                            fontSize: 20,fontWeight: FontWeight.w300,color: Colors.white
                          ),
                          ),
                        ),
                        Container(
                          width: Globals.width *0.15,
                          child: Icon(Icons.arrow_forward, color: Colors.white,),
                        )
                      ],
                    ),
                  )
              )),
          Positioned(
              top: Globals.height * 0.6,
              left: Globals.width * 0.05,
              child: Container(
                  width: Globals.width * 0.35,
                  child: Divider(
                    thickness: 2.0,
                  )
              )),
          Positioned(
              top: Globals.height * 0.6,
              left: Globals.width * 0.4,
              child: Container(
                width: Globals.width * 0.2,
                height: Globals.height * 0.08,
                child: AutoSizeText('OR\nSign in\nWith', textAlign: TextAlign.center,),
              )),
          Positioned(
              top: Globals.height * 0.6,
              right: Globals.width * 0.05,
              child: Container(
                  width: Globals.width * 0.35,
                  child: Divider(
                    thickness: 2.0,
                  )
              )),
          Positioned(
              top: Globals.height * 0.7,
              left: Globals.width * 0.1,
              child: Container(
                  height: Globals.height * 0.06,
                  width: Globals.width * 0.8,
                  decoration: BoxDecoration(
                      color: ColorStyle.button_red,
                      borderRadius: BorderRadius.circular(30.0)
                  ),
                  child: TextButton(
                    onPressed: () async{
                      _loadingDialog('Authenticating');
                      try{
                        fAuth.User u = await loginWithFacebook(context);
                        bool res = await fdb.FirebaseDB.getUserDetails(u.uid, context);
                        if(res){
                          Globals.user = new User(u.photoURL, u.displayName, u.uid, u.email, u.phoneNumber);
                          Navigator.pop(context);
                          Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context){
                            return EditProfile();
                          }));
                        }
                        else{
                          Navigator.pop(context);
                          Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context){
                            return HomeScreen();
                          }));
                        }
                      }
                      catch(e){
                        Navigator.pop(context);
                      }
                    },
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: Globals.width *0.1),
                          width: Globals.width * 0.15,
                          child: Image.asset(Images.facebook_logo),
                        ),
                        Container(
                          width: Globals.width * 0.45,
                          child: AutoSizeText('Sign In With Facebook',
                            style: GoogleFonts.montserrat(
                                fontSize: 20, color: Colors.white,
                                fontWeight: FontWeight.w300),
                            textAlign: TextAlign.center,),
                        )

                      ],
                    ),
                  )
              )),
          Positioned(
              top: Globals.height * 0.8,
              left: Globals.width * 0.1,
              child: Container(
                  height: Globals.height * 0.06,
                  width: Globals.width * 0.8,
                  decoration: BoxDecoration(
                      color: ColorStyle.button_red,
                      borderRadius: BorderRadius.circular(30.0)
                  ),
                  child: TextButton(
                    onPressed: () async {
                      _loadingDialog('Authenticating');
                      try{
                        fAuth.User u = await signInWithGoogle();
                        if(u!=null){
                          bool res = await fdb.FirebaseDB.getUserDetails(u.uid, context);
                          if(res){
                            Globals.user = new User(u.photoURL, u.displayName, u.uid, u.email, u.phoneNumber);
                            Navigator.pop(context);
                            Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context){
                              return EditProfile();
                            }));
                          }
                          else{
                            Navigator.pop(context);
                            Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context){
                              return HomeScreen();
                            }));
                          }
                        }
                        else{
                          Toast.show('Internet Error. Login failed, please try again.',context);
                          Navigator.pop(context);
                        }
                      }
                      catch(e){
                        Navigator.pop(context);
                      }

                    },
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: Globals.width *0.1),
                          width: Globals.width * 0.15,
                          child: Image.asset(Images.google_logo),
                        ),
                        Container(
                          width: Globals.width * 0.45,
                          child: AutoSizeText('Sign In With Google',
                            style: GoogleFonts.montserrat(
                                fontSize: 20, color: Colors.white,fontWeight: FontWeight.w300),
                            textAlign: TextAlign.center,),
                        )
                      ],
                    ),
                  )
              )),
          Positioned(
              top: Globals.height * 0.9,
              right: Globals.width * 0.1,
              child: Container(
                  width: Globals.width * 0.8,
                  child: Divider(
                    color: Colors.black,
                  )
              )),

        ],
      ),
    );
  }
}
