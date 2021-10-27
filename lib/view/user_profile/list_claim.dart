import 'package:auto_size_text/auto_size_text.dart';
import 'package:facto_user/database/firebase.dart';
import 'package:facto_user/model/search_results.dart';
import 'package:facto_user/util/colors.dart';
import 'package:facto_user/util/globals.dart';
import 'package:facto_user/util/images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ListClaims extends StatefulWidget {
  final String Status;

  ListClaims(this.Status);

  @override
  _ListClaimsState createState() => _ListClaimsState();
}

class _ListClaimsState extends State<ListClaims> {
  TextEditingController _searchController = new TextEditingController();
  FocusNode focusNode = new FocusNode();
  var data = List.filled(0, new SearchResults.fromJson({
    'news' : '',
    'claimId' : '',
    'requestedByUid' : '',
    'url2' : '',
    'status' : '',
  }), growable: true);
  var tempData = List.filled(0, new SearchResults.fromJson({
    'news' : '',
    'claimId' : '',
    'requestedByUid' : '',
    'url2' : '',
    'status' : '',
  }), growable: true);

  @override
  void initState() {
    super.initState();
    _getData();
  }
  bool isLoading = true;


  void _openAddEntryDialog(String claim, String url,
      String status, BuildContext context
      ) {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new CardDialog(claim, url,
              status
          );
        },
        fullscreenDialog: true
    ));
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
  _getData() async{
    data = await FirebaseDB.getFilteredRequests(this.widget.Status).whenComplete((){
     setState(() {
       isLoading = false;
     });
    });
    tempData = data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFEDF2F4),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: new Image.asset(
              Images.back_btn,
              height: Globals.height * (24 / 812),
              width: Globals.width * (24 / 375),
            ),
          ),
          actions: [
            Container(
              width: Globals.width,
              padding: EdgeInsets.symmetric(vertical: 15),
              child: AutoSizeText(
                'Fact Check Requests',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        backgroundColor: Colors.white,
        body: isLoading?_loadingScreen('Loading Data...'):Stack(
          children: [
            Positioned(
                top: Globals.height * 0.05,
                left: Globals.width * 0.1,
                child: Container(
                  width: Globals.width * 0.8,
                  height: Globals.getHeight(60),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2.0),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: TextField(
                    controller: _searchController,
                    focusNode: focusNode,
                    onChanged: (value) {
                      if(value.length == 0){
                        setState(() {
                          tempData = data;
                        });
                        focusNode.unfocus();
                      }
                      else{
                        var result = List.filled(0, new SearchResults.fromJson({
                          'news' : '',
                          'claimId' : '',
                          'requestedByUid' : '',
                          'url2' : '',
                          'status' : '',
                        }), growable: true);
                        data.forEach((element) {
                          if(element.news.contains(value.trim())){
                            result.add(element);
                          }
                        });
                        setState(() {
                          tempData = result;
                        });
                      }
                    },
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                        hintText: 'Search Here',

                        hintStyle: TextStyle(fontSize: 20),
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 20),
                        border: InputBorder.none,
                        suffixIcon: Icon(
                          Icons.search,
                          color: Colors.black,
                          size: 30,
                        )),
                  ),
                )),
            Positioned(
              top: Globals.height * 0.15,
              left: 0.0,
              child: Container(
                height: Globals.height * 0.795,
                width: Globals.width,
                color: Colors.white,
                child: tempData.length == 0?Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Image.asset(Images.no_data,height: 250,width: 250,),
                    Text('No Data',style: GoogleFonts.montserrat(fontSize: 30),)
                  ],
                ),):ListView(
                  children: List.generate(tempData.length, (index) {
                    return GestureDetector(
                      onTap: (){
                        _openAddEntryDialog(tempData[index].news, tempData[index].url2,tempData[index].status, context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: (index + 1) % 2 == 0
                                ? Color(0xFFFFEEF0)
                                : Colors.white,
                            border: Border.all(
                              color: Colors.grey,
                            )),
                        width: Globals.width,
                        padding: EdgeInsets.all(5.0),
                        height: Globals.getHeight(80),
                        child: Stack(
                          children: [
                            Positioned(
                              top: Globals.height * (7 / 812),
                              left: Globals.width * (12 / 375),
                              child: Container(
                                height: Globals.width * (40 / 375),
                                width: Globals.width * (40 / 375),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        Globals.getHeight(30)),
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(tempData[index].url2))),
                              ),
                            ),
                            Positioned(
                              left: Globals.width * (80 / 375),
                              top: Globals.height * (22 / 812),
                              child: Container(
                                width: Globals.width * (276 / 375),
                                child: AutoSizeText(
                                  tempData[index].news,
                                  style: GoogleFonts.montserrat(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w300),
                                  minFontSize: 15.0,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            )
          ],
        ));
  }
}


class CardDialog extends StatefulWidget {
  final String claim;
  final String url;
  final String status;


  CardDialog(this.claim, this.url, this.status);

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
          icon: Icon(Icons.close,
            color: Colors.black,),
          onPressed: (){
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
              left: Globals.width * 0.1,
              child: Container(
                padding: EdgeInsets.all(20),
                height: Globals.height * 0.15,
                width: Globals.width * 0.8,
                decoration: BoxDecoration(
                    color: Color(0xFFEDF2F4),
                    border: Border.all(color: Colors.red, width: 2.0),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        bottomRight: Radius.circular(40.0))),
                child: Center(
                  child: Text(this.widget.claim,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 25)),
                ),
              ),
            ),
            this.widget.url!=null?Positioned(
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
                  image: DecorationImage(
                      image: NetworkImage(this.widget.url), fit: BoxFit.cover),
                ),
              ),
            ):SizedBox(),
            Positioned(
              top: Globals.height * 0.65,
              left: Globals.width * 0.1,
              child: Container(
                padding: EdgeInsets.all(10.0),
                height: Globals.height * 0.15,
                width: Globals.width * 0.8,
                child: Center(
                  child: Text(this.widget.status=='Pending'?'Your fact check is still in progress please check later.':this.widget.status=='True'?'Your fact check has been completed, and the claim appears to be true.':'Your fact check has been completed, and the claim appears to be false.',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                ),
                decoration: BoxDecoration(
                    color: this.widget.status=='Pending'?ColorStyle.in_progress.withOpacity(0.2):this.widget.status=='True'?ColorStyle.completed.withOpacity(0.2):ColorStyle.rejected.withOpacity(0.2),
                    border: Border.all(color: this.widget.status=='Pending'?ColorStyle.in_progress.withOpacity(0.6):this.widget.status=='True'?ColorStyle.completed.withOpacity(0.6):ColorStyle.rejected.withOpacity(0.6), width: 2.0),
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
              top: Globals.height * 0.63,
              right: Globals.width * 0.17,
              child: Container(
                width: Globals.width * 0.3,
                height: Globals.getHeight(50),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: this.widget.status=='Pending'?ColorStyle.in_progress:this.widget.status=='True'?ColorStyle.completed:ColorStyle.rejected),
                child: Center(
                  child: Text(
                    'Status',
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
