import 'dart:async';
import 'dart:ui';

import 'package:facto_user/util/colors.dart';
import 'package:facto_user/util/globals.dart';
import 'package:facto_user/view/home_screen/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailScreen extends StatefulWidget {

  String name;
  String url;


  DetailScreen(this.name, this.url);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();
    navigate();
  }

  navigate() {
    Timer t = new Timer(
        new Duration(
          milliseconds: 1200,
        ), () {
          setState(() {
            Globals.category = this.widget.name;
          });
      Navigator.of(context).push(new MaterialPageRoute(builder: (context){return HomeScreen();}));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorStyle.button_red,
        body: Container(
          width: Globals.width,
          height: Globals.height,
          margin: EdgeInsets.symmetric(horizontal: Globals.width * 0.02),
          decoration: BoxDecoration(
            color: ColorStyle.button_red,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: ColorStyle.button_red),
          ),
          child: Center(
            child: Stack(
              children: [
                Positioned(child: Container(
                  height: Globals.width * 0.5,
                  width: Globals.width * 0.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: NetworkImage(this.widget.url),fit: BoxFit.cover
                    ),
                  ),
                ),top: Globals.height *0.4,left: Globals.width * 0.25,),
                Positioned(
                    left: Globals.width * 0.0,
                    bottom: Globals.height * 0.3,
                    child: Container(
                      height: Globals.height * 0.05,
                      width: Globals.width,
                      child: Text(
                        this.widget.name,
                        style: GoogleFonts.montserrat(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ))
              ],
            ),
          ),
        ));
  }
}
