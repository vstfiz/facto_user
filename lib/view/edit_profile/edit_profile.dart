import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:facto_user/model/user.dart';
import 'package:facto_user/util/colors.dart';
import 'package:facto_user/util/globals.dart';
import 'package:facto_user/util/images.dart';
import 'package:facto_user/view/home_screen/home_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:facto_user/database/firebase.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

import 'package:toast/toast.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController _firstNameController = new TextEditingController();
  TextEditingController _lastNameController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  String firstNameError;
  String lastNameError;
  String phoneError;
  String emailError;
  var nodes = [
    new FocusNode(),
    new FocusNode(),
    new FocusNode(),
    new FocusNode(),
  ];

  bool _selectedImage = false;
  File _file;

  @override
  initState(){
    super.initState();
    try{
      _firstNameController.text = Globals.user.name.split(" ")[0];
      _lastNameController.text = Globals.user.name.split(" ")[1];
      _emailController.text = Globals.user.email;
      _phoneController.text = Globals.user.phone;
    }
    catch(e){
      print(e);
    }
  }

  Future<String> _uploadImage(File file) async {
    print("image upload running");
    final Reference ref = FirebaseStorage.instance.ref().child(
        'users/${Globals.user.uid}/dp}.jpg');
    final UploadTask uploadTask = ref.putFile(file);
    await uploadTask;
    var uri = await ref.getDownloadURL();
    print(uri.toString());
    return uri.toString();
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: true,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFFEDF2F4),
            leading: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Container(
                  height: Globals.height * (20 / 812),
                  width: Globals.width * (20 / 375),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      Images.back_btn,
                    ),
                    fit: BoxFit.contain
                  )
                ),
              )
            ),
            actions: [
              Container(
                width: Globals.width,
                padding: EdgeInsets.symmetric(vertical: 15),
                child: AutoSizeText(
                  'Profile',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          body: Container(
            width: Globals.width,
            height: Globals.height * 0.85,
            margin: EdgeInsets.only(top: 5.0),
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
            ),
            child: SingleChildScrollView(
              child:  Stack(
                children: [
                  Container(
                    width: Globals.width,
                    height: Globals.height * 0.85,
                  ),
                  Positioned(
                      top: 0.0,
                      right: 0.0,
                      child: Container(
                        width: Globals.width,
                        height: Globals.height * 0.4,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image:
                                AssetImage(Images.sign_in_background_pattern),
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
                                  image: AssetImage(
                                      Images.sign_in_background_pattern),
                                  fit: BoxFit.cover)),
                        ),
                        angle: math.pi,
                      )),
                  Positioned(
                      top: Globals.height * (46 / 812),
                      left: Globals.width * (124 / 375),
                      child: Container(
                        height: Globals.height * (127 / 812),
                        width: Globals.width * (127 / 375),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: _selectedImage?FileImage(_file):NetworkImage(
                                    Globals.user.dp),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(
                                Globals.width * (43 / 375))),
                      )),
                  Positioned(
                      top: Globals.height * (147 / 812),
                      left: Globals.width * (227 / 375),
                      child: Container(
                        height: Globals.height * (30 / 812),
                        width: Globals.width * (30 / 375),
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.72),
                            borderRadius: BorderRadius.circular(
                                Globals.width * (30 / 375) * (9 / 30))),
                        child: IconButton(
                          onPressed: () async {
                            FilePickerResult result =
                            await FilePicker.platform.pickFiles(
                              type: FileType.image,
                            );
                            if (result != null) {
                              String path = result.files.first.path;
                              _file = File(path);
                              setState(() {
                                _selectedImage = true;
                              });
                            }
                          },
                          icon: Image.asset(
                            Images.edit_profile,
                            width: Globals.width * (20 / 375),
                            height: Globals.height * (20 / 812),
                          ),
                        ),
                      )),
                  Positioned(
                      top: Globals.height * (199 / 812),
                      left: Globals.width * (59 / 375),
                      child: Container(
                          width: Globals.width * (80 / 375),
                          height: Globals.height * (30 / 812),
                          child: AutoSizeText(
                            'First Name',
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w300,
                                fontSize: 17,
                                color: Color(0xFF989898)),
                          ))),
                  Positioned(
                      top: Globals.height * (224 / 812),
                      left: Globals.width * (37 / 375),
                      child: Container(
                        width: Globals.width * (301 / 375),
                        height: Globals.height * (48 / 812),
                        decoration: BoxDecoration(
                            color: ColorStyle.text_field_Color,
                            borderRadius: BorderRadius.circular(
                                Globals.width * 0.75 * (29 / 301)),
                            border:
                            Border.all(width: 0.5, color: Color(0xFFC3C2C3))),
                        child: TextField(
                          controller: _firstNameController,
                          focusNode: nodes[0],
                          style: GoogleFonts.montserrat(
                              fontSize: 18, color: ColorStyle.text_Color),
                          decoration: InputDecoration(
                            errorText: firstNameError,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 20.0),
                          ),
                        ),
                      )),
                  Positioned(
                      top: Globals.height * (294 / 812),
                      left: Globals.width * (59 / 375),
                      child: Container(
                          width: Globals.width * (80 / 375),
                          height: Globals.height * (30 / 812),
                          child: AutoSizeText(
                            'Last Name',
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w300,
                                fontSize: 17,
                                color: Color(0xFF989898)),
                          ))),
                  Positioned(
                      top: Globals.height * (319 / 812),
                      left: Globals.width * (37 / 375),
                      child: Container(
                        width: Globals.width * (301 / 375),
                        height: Globals.height * (48 / 812),
                        decoration: BoxDecoration(
                            color: ColorStyle.text_field_Color,
                            borderRadius: BorderRadius.circular(
                                Globals.width * 0.75 * (29 / 301)),
                            border:
                            Border.all(width: 0.5, color: Color(0xFFC3C2C3))),
                        child: TextField(
                          controller: _lastNameController,
                          focusNode: nodes[1],
                          style: GoogleFonts.montserrat(
                              fontSize: 18, color: ColorStyle.text_Color),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 20.0),
                          ),
                        ),
                      )),
                  Positioned(
                      top: Globals.height * (389 / 812),
                      left: Globals.width * (59 / 375),
                      child: Container(
                          width: Globals.width * (80 / 375),
                          height: Globals.height * (30 / 812),
                          child: AutoSizeText(
                            'Phone',
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w300,
                                fontSize: 17,
                                color: Color(0xFF989898)),
                          ))),
                  Positioned(
                      top: Globals.height * (414 / 812),
                      left: Globals.width * (37 / 375),
                      child: Container(
                        width: Globals.width * (301 / 375),
                        height: Globals.height * (48 / 812),
                        decoration: BoxDecoration(
                            color: ColorStyle.text_field_Color,
                            borderRadius: BorderRadius.circular(
                                Globals.width * 0.75 * (29 / 301)),
                            border:
                            Border.all(width: 0.5, color: Color(0xFFC3C2C3))),
                        child: TextField(
                          controller: _phoneController,
                          focusNode: nodes[2],
                          onChanged: (value) {
                            RegExp _phonePattern = new RegExp(r'^[1-9]{1}[0-9]{9}$');
                            if (!_phonePattern.hasMatch(value.trim())) {
                              setState(() {
                                phoneError = 'Please Input valid Phone Number';
                              });
                            } else {
                              setState(() {
                                phoneError = null;
                              });
                              nodes[2].unfocus();
                            }
                          },
                          style: GoogleFonts.montserrat(
                              fontSize: 18, color: ColorStyle.text_Color),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            errorText: phoneError,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 20.0),
                          ),
                        ),
                      )),
                  Positioned(
                      top: Globals.height * (484 / 812),
                      left: Globals.width * (59 / 375),
                      child: Container(
                          width: Globals.width * (80 / 375),
                          height: Globals.height * (30 / 812),
                          child: AutoSizeText(
                            'Email',
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w300,
                                fontSize: 17,
                                color: Color(0xFF989898)),
                          ))),
                  Positioned(
                      top: Globals.height * (509 / 812),
                      left: Globals.width * (37 / 375),
                      child: Container(
                        width: Globals.width * (301 / 375),
                        height: Globals.height * (48 / 812),
                        decoration: BoxDecoration(
                            color: ColorStyle.text_field_Color,
                            borderRadius: BorderRadius.circular(
                                Globals.width * 0.75 * (29 / 301)),
                            border:
                            Border.all(width: 0.5, color: Color(0xFFC3C2C3))),
                        child: TextField(
                          controller: _emailController,
                          focusNode: nodes[3],
                          onChanged: (value) {
                            RegExp _emailPattern = new RegExp(
                                r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                            if (!_emailPattern.hasMatch(value.trim())) {
                              setState(() {
                                emailError = 'Please Input valid Email';
                              });
                            } else {
                              setState(() {
                                emailError = null;
                              });
                              nodes[3].unfocus();
                            }
                          },
                          style: GoogleFonts.montserrat(
                              fontSize: 18, color: ColorStyle.text_Color),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            errorText: emailError,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 20.0),
                          ),
                        ),
                      )),
                  Positioned(
                    top: Globals.height * (594 / 812),
                    left: Globals.width * (99 / 375),
                    child: Container(
                      width: Globals.width * (179 / 375),
                      height: Globals.height * (52 / 812),
                      decoration: BoxDecoration(
                          color: ColorStyle.button_red,
                          borderRadius:
                          BorderRadius.circular(Globals.width * (28 / 375))),
                      child: TextButton(
                        onPressed: () async{
                          if(_firstNameController.text.trim() != ''){
                            if(_lastNameController.text.trim() != ''){
                              if(_phoneController.text.trim()!= ''){
                                _loadingDialog('Uploading Data...');
                                try{
                                  String url;
                                  if(_file!= null){
                                    url = await _uploadImage(_file);
                                  }
                                  else{
                                    url = Globals.user.dp;
                                  }
                                  await FirebaseDB.createUser(Globals.user.uid, _emailController.text, url, _firstNameController.text + " " + _lastNameController.text, _phoneController.text, context);
                                  Globals.user = new User(url,  _firstNameController.text + " " + _lastNameController.text, Globals.user.uid,  _emailController.text,  _phoneController.text);
                                  Navigator.pop(context);
                                  Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context){return HomeScreen();}));
                                }
                                catch(e){
                                  Navigator.pop(context);
                                }
                              }
                              else{
                                Toast.show('Enter value in Phone',context);
                              }
                            }
                            else{
                              Toast.show('Enter value in last name',context);
                            }
                          }
                          else{
                            Toast.show('Enter value in first name', context);
                          }
                        },
                        child: Text(
                          'Submit',
                          style: GoogleFonts.montserrat(
                              fontSize: 20.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
