import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:facto_user/database/firebase.dart';
import 'package:facto_user/util/colors.dart';
import 'package:facto_user/util/globals.dart';
import 'package:facto_user/util/images.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:math' as math;
import 'package:image/image.dart' as Im;

import 'package:google_fonts/google_fonts.dart';
import 'package:toast/toast.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FileClaim extends StatefulWidget {
  @override
  _FileClaimState createState() => _FileClaimState();
}

class _FileClaimState extends State<FileClaim> {
  bool acceptTnc = false;
  TextEditingController _claimController = new TextEditingController();
  TextEditingController _imageController = new TextEditingController();
  TextEditingController _url1Controller = new TextEditingController();
  TextEditingController _url2Controller = new TextEditingController();
  TextEditingController _descriptionController = new TextEditingController();
  File _file;
  String uri = 'Image';
  String imageName;

  String claimError;

  Future<String> _uploadImage(File file) async {
    print("image upload running");
    final Reference ref = FirebaseStorage.instance.ref().child(
        'users/${Globals.user.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg');
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

  Future<void> _successCard(BuildContext context) {
    return showDialog<void>(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
                side: BorderSide(color: Color(0xFF06B359)),
                borderRadius: BorderRadius.circular(Globals.width * (20 / 375))),
            backgroundColor: Color(0xFFF3FFF9),
            content: Stack(
              children: [
                Positioned(
                  top: 0.0,
                  right: 0.0,
                  child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _claimController.clear();
                        _file = null;
                        _url2Controller.clear();
                        _descriptionController.clear();
                        _url1Controller.clear();
                        uri = 'Image';
                        imageName = '';
                        acceptTnc = false;
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
                Container(
                    height: Globals.width * 0.65,
                    width: Globals.width * 0.8,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(Images.confirmation,height: 170,width: 170,),
                          Text('Successfully\nSubmitted',style: GoogleFonts.ubuntu(
                              fontSize: 22,fontWeight: FontWeight.w500
                          ),textAlign: TextAlign.center,)
                        ]
                    ))
              ],
            )));
  }

  Future<void> _tncDialog() {
    return showDialog<void>(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              backgroundColor: Colors.white,
              content: Container(
                  height: Globals.height * 0.7,
                  width: Globals.width,
                  child: WebView(
                    initialUrl: 'https://factonews.co/code-of-principles/',
                  )),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: (Text('Dismiss')))
              ],
            ));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFEDF2F4),
        actions: [
         Stack(
           alignment: Alignment.center,
           children: [
             Container(
               width: Globals.width,
               child: AutoSizeText(
                 'Fact Check',
                 textAlign: TextAlign.center,
                 style: GoogleFonts.montserrat(
                     fontSize: 20, fontWeight: FontWeight.bold),
               ),
             ),
             Positioned(child: Container(
               height: Globals.height * (50 / 812),
               width: Globals.width * (40 / 375),
               child: TextButton(
                 onPressed: () {
                   if(Globals.currentTab != 2){
                     setState(() {
                       Globals.currentTab = 2;
                       Globals.pageController.jumpToPage(2);
                     });
                   }
                   else{
                     Navigator.of(context).pop();
                   }
                 },child: new Image.asset(
                 Images.back_btn,
                 height: Globals.height * (24 / 812),
                 width: Globals.width * (24 / 375),
               ),),

             ),left: 0.0)
             
           ],
         )
        ],
      ),
      backgroundColor: Colors.white,
      body:
     SingleChildScrollView(
       child:  Stack(
         children: [
           Container(
             height: Globals.height,
             width: Globals.width,
           ),
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
                   height: Globals.height * 0.4,
                   decoration: BoxDecoration(
                       image: DecorationImage(
                           image: AssetImage(Images.sign_in_background_pattern),
                           fit: BoxFit.cover)),
                 ),
                 angle: math.pi,
               )),
           Positioned(
               top: Globals.height * (30/812),
               left: Globals.width * (102/375),
               child: Container(
                 width: Globals.width * (172/375),
                 height: Globals.height * (67/812),
                 decoration: BoxDecoration(
                     image: DecorationImage(image: AssetImage(Images.logo))),
               )),
           Positioned(
               top: Globals.height * (126/812),
               left: Globals.width * (37/375),
               child: Container(
                 width: Globals.width * 0.75,
                 height: Globals.height * 0.06,
                 decoration: BoxDecoration(
                     color: ColorStyle.text_field_Color,
                     borderRadius: BorderRadius.circular(Globals.width * 0.75 * (29/301)),
                     border: Border.all(width: 0.5,color: Color(0xFFC3C2C3))),
                 child: TextField(
                   controller: _claimController,
                   onChanged: (value){
                     if(_claimController.text.length > 450){
                       setState(() {
                         claimError = 'Claim entered can have a max length of 450 char';
                       });
                     }
                   },
                   style:
                   GoogleFonts.montserrat(fontSize: 18, color: ColorStyle.text_Color),
                   decoration: InputDecoration(
                       border: InputBorder.none,
                       errorText: claimError,
                       contentPadding:
                       EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                       hintText: 'Claim',
                       hintStyle: TextStyle(
                           color: Color(0xFFC3C2C3)
                       )),
                 ),
               )),
           Positioned(
             top: Globals.height * (204/812),
             left: Globals.width * (37/375),
             child: Container(
                 width: Globals.width * 0.75,
                 height: Globals.height * 0.06,
                 decoration: BoxDecoration(
                     color: ColorStyle.text_field_Color,
                     borderRadius: BorderRadius.circular(30),
                     border: Border.all(width: 0.5,color: Color(0xFFC3C2C3))),
                 child: Stack(
                   children: [
                     Positioned(
                       left: 20.0,
                       top: 15.0,
                       child: Container(
                         width: Globals.width * 0.4,
                         padding: EdgeInsets.symmetric(vertical:Globals.getHeight( 7.0)),
                         child: Text(
                           _file==null?'Image':imageName,
                           style: GoogleFonts.montserrat(
                               fontSize: 15, color: _file==null?Color(0xFFC3C2C3):ColorStyle.text_Color),overflow: TextOverflow.ellipsis,
                         ),
                       ),
                     ),
                     Positioned(right: 10.0,top: Globals.getHeight(7.0),child: IconButton(
                       onPressed: () async {
                         FilePickerResult result =
                         await FilePicker.platform.pickFiles(
                           type: FileType.image,
                         );
                         if (result != null) {
                           _loadingDialog('Uploading Image...');
                           try{
                             String path = result.files.first.path;
                             _file = File(path);
                             String url = await _uploadImage(_file);
                             setState(() {
                               imageName = result.files.first.name;
                               uri = url;
                             });
                             Navigator.pop(context);
                           }
                           catch(e){
                             print(e);
                             Navigator.pop(context);
                           }
                         }
                       },
                       icon: Icon(Icons.image,color: Color(0xFFC3C2C3),),
                     ))
                   ],
                 )),
           ),
           Positioned(
               top: Globals.height * (282/812),
               left: Globals.width * (37/375),
               child: Container(
                 width: Globals.width * 0.75,
                 height: Globals.height * 0.06,
                 decoration: BoxDecoration(
                     color: ColorStyle.text_field_Color,
                     borderRadius: BorderRadius.circular(Globals.width * 0.75 * (29/301)),
                     border: Border.all(width: 0.5,color: Color(0xFFC3C2C3))),
                 child: TextField(
                   controller: _url1Controller,
                   style:
                   GoogleFonts.montserrat(fontSize: 18, color: ColorStyle.text_Color),
                   decoration: InputDecoration(
                       border: InputBorder.none,
                       contentPadding:
                       EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                       hintText: 'Url1',
                       hintStyle: TextStyle(
                           color: Color(0xFFC3C2C3)
                       )),
                 ),
               )),
           Positioned(
               top: Globals.height * (360/812),
               left: Globals.width * (37/375),
               child: Container(
                 width: Globals.width * 0.75,
                 height: Globals.height * 0.06,
                 decoration: BoxDecoration(
                     color: ColorStyle.text_field_Color,
                     borderRadius: BorderRadius.circular(Globals.width * 0.75 * (29/301)),
                     border: Border.all(width: 0.5,color: Color(0xFFC3C2C3))),
                 child: TextField(
                   controller: _url2Controller,
                   style:
                   GoogleFonts.montserrat(fontSize: 18, color: ColorStyle.text_Color),
                   decoration: InputDecoration(
                       border: InputBorder.none,
                       contentPadding:
                       EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                       hintText: 'Url2',
                       hintStyle: TextStyle(
                           color: Color(0xFFC3C2C3)
                       )),
                 ),
               )),
           Positioned(
               top: Globals.height * (438/812),
               left: Globals.width * (37/375),
               child: Container(
                 width: Globals.width * 0.75,
                 height: Globals.height * 0.06,
                 decoration: BoxDecoration(
                     color: ColorStyle.text_field_Color,
                     borderRadius: BorderRadius.circular(Globals.width * 0.75 * (29/301)),
                     border: Border.all(width: 0.5,color: Color(0xFFC3C2C3))),
                 child: TextField(
                   controller: _descriptionController,
                   style:
                   GoogleFonts.montserrat(fontSize: 18, color: ColorStyle.text_Color),
                   decoration: InputDecoration(
                       border: InputBorder.none,
                       contentPadding:
                       EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                       hintText: 'Description',
                       hintStyle: TextStyle(
                           color: Color(0xFFC3C2C3)
                       )),
                 ),
               )),
           Positioned(
               top: Globals.height * (521/812),
               left: Globals.width * (79/375),
               child: Container(
                 width: Globals.width * (17/375),
                 height: Globals.height * (17/812),
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(30),
                 ),
                 child:
                 Checkbox(
                     value: acceptTnc,
                     onChanged: (value) {
                       setState(() {
                         acceptTnc = value;
                       });
                     }),)),
           Positioned(
               top: Globals.height * (521/812),
               left: Globals.width * (126/375),
               child: Container(
                   width: Globals.width * (124/375),
                   height: Globals.height * (40/812),
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(30),
                   ),
                   child:
                   GestureDetector(
                     onTap: (){
                       _tncDialog();
                     },
                     child: RichText(
                       textAlign: TextAlign.center,
                       text: TextSpan(children: <TextSpan>[
                         TextSpan(
                             text: "I agree to the ",
                             style: GoogleFonts.montserrat(color: ColorStyle.text_Color)),
                         TextSpan(
                             text: "T&C",
                             style: GoogleFonts.montserrat(
                                 color: Colors.blue,
                                 fontWeight: FontWeight.bold)),
                       ]),
                     ),
                   )
               )),
           Positioned(
               top: Globals.height * (570/812),
               left: Globals.width * (60.3/375),
               child: Container(
                   width: Globals.width * (250/375),
                   height: Globals.height * (52/812),
                   decoration: BoxDecoration(
                     color: ColorStyle.button_red,
                     borderRadius: BorderRadius.circular(Globals.width * (250/375) * (28/250)),
                   ),
                   child: TextButton(
                     onPressed: ()async{
                       if(acceptTnc){
                         if(_claimController.text.trim() != ''){
                           _loadingDialog('Uploading Claim...');
                           try{
                             await FirebaseDB.createClaim(_descriptionController.text,_url1Controller.text,_url2Controller.text,uri,_claimController.text,context);
                             Navigator.pop(context);
                             _successCard(context);

                           }
                           catch(e){
                             Navigator.pop(context);
                           }
                         }
                         else{
                           Toast.show('Enter a valid Claim', context);
                         }
                       }
                       else{
                         Toast.show('Please Accept the terms', context);
                       }
                     },
                     child: Text(
                       'Submit',
                       style: GoogleFonts.montserrat(
                           color: Colors.white, fontSize: 20,fontWeight: FontWeight.w300),
                       textAlign: TextAlign.center,
                     ),
                   )
               )
           ),
         ],
       ),
     ),
    );
  }
}
