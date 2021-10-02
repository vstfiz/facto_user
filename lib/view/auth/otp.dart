import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:facto_user/services/auth/auth.dart';
import 'package:facto_user/util/colors.dart';
import 'package:facto_user/util/globals.dart';
import 'package:facto_user/util/images.dart';
import 'package:facto_user/view/auth/sign_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp/flutter_otp.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:toast/toast.dart';

class OTP extends StatefulWidget {
  final String phone;

  OTP(this.phone);

  @override
  _OTPState createState() => new _OTPState();
}

class _OTPState extends State<OTP> with SingleTickerProviderStateMixin {
  final int time = 30;
  int timeInSeconds;
  FlutterOtp otp = new FlutterOtp();
  String smsOtp;
  Timer t;

  @override
  void initState() {
    super.initState();
    _sendOtp();
    _startCountdown();
  }

  _sendOtp() async {
    await verifyPhone(this.widget.phone, context);
  }

  Future<Null> _startCountdown() async {
    timeInSeconds = time;
    t = new Timer.periodic(new Duration(seconds: 1), (timer) {
      if (timeInSeconds > 0) {
        setState(() {
          print(timeInSeconds);
          timeInSeconds--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  get _getTimerText {
    return Container(
      height: Globals.height * 0.05,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new TextButton(
            child: AutoSizeText(
              'Resend: ',
              style: GoogleFonts.montserrat(
                  fontSize: 20.0,
                  color: timeInSeconds == 0 ? Colors.blue : Colors.black),
            ),
            onPressed: () {
              print('Resend Otp');
            },
          ),
          new Icon(Icons.access_time),
          new SizedBox(
            width: 5.0,
          ),
          Text(
            timeInSeconds.toString(),
            style: GoogleFonts.montserrat(fontSize: 20),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              )), Positioned(
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
            child: IconButton(
              onPressed: (){
                t.cancel();
                Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context){return SignIn();}));
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
              top: Globals.height * 0.1539,
              left: Globals.width * 0.181,
              child: Container(
                width: Globals.width * 0.6373,
                height: Globals.height * 0.1145,
                decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage(Images.logo))),
              )),
          Positioned(
              top: Globals.height * 0.2687,
              left: Globals.width * 0.3013,
              child: Container(
                width: Globals.width * 0.4,
                height: Globals.height * 0.0492,
                child: Text(
                  'Welcome!',
                  style: GoogleFonts.montserrat(fontSize: 30.0),
                  textAlign: TextAlign.center,
                ),
              )),
          Positioned(
              top: Globals.height * 0.4064,
              left: Globals.width * 0.3493,
              child: Container(
                width: Globals.width * 0.3013,
                height: Globals.height * 0.03325,
                child: AutoSizeText(
                  'Enter OTP',
                  style: GoogleFonts.montserrat(fontSize: 28.0),
                  textAlign: TextAlign.center,
                ),
              )),
          Positioned(
              top: Globals.height * 0.4642,
              left: Globals.width * 0.1,
              child: Container(
                  height: Globals.height * 0.1,
                  width: Globals.width * 0.8,
                  child: PinCodeTextField(
                      appContext: context,
                      length: 6,
                      onChanged: (value) {
                        print(value);
                        setState(() {
                          smsOtp = value;
                        });
                      }))),
          Positioned(
              top: Globals.height * 0.6,
              left: Globals.width * 0.3,
              child: Container(
                  height: Globals.height * 0.064,
                  width: Globals.width * 0.45,
                  decoration: BoxDecoration(
                      color: ColorStyle.button_red,
                      borderRadius: BorderRadius.circular( Globals.width * 0.45 * 0.165)),
                  child: TextButton(
                    onPressed: () async{
                      print(smsOtp);
                      if(smsOtp.length == 6){
                        try{
                          await signInWithPhone(smsOtp,context);
                          t.cancel();
                        }
                        catch(e){
                          if(e.code == 'ERROR_INVALID_VERIFICATION_CODE'){
                            Toast.show('Invalid OTP', context);
                            print(e.code);
                          }
                        }
                      }
                      else{
                        Toast.show('Enter Valid OTP',context);
                      }
                    },
                    child: Text(
                      'Next',
                      style: GoogleFonts.montserrat(
                          fontSize: 20, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ))),
          Positioned(
              top: Globals.height * 0.65,
              left: Globals.width * 0.3,
              child: Container(
                  height: Globals.height * 0.06,
                  width: Globals.width * 0.4,
                  child: _getTimerText)),
        ],
      ),
    );
  }
}
