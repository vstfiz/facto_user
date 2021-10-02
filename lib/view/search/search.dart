import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facto_user/model/search_results.dart';
import 'package:facto_user/services/searching/searching.dart';
import 'package:facto_user/util/globals.dart';
import 'package:facto_user/util/images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController _searchController = new TextEditingController();
  var queryResults = [];
  var tempStorage = [];

  _getData() async{
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('feeds')
        .get();
    querySnapshot.docs.forEach((element) {
        queryResults.add(element);
    });
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }
  // var data = List.filled(
  //     25,
  //     new SearchResults(
  //         'https://iotcdn.oss-ap-southeast-1.aliyuncs.com/News-Image.jpg',
  //         'Lorem ispum fverf fewfewr few',
  //         'claimId'));

  void _openAddEntryDialog(String claim, String url, String url1,
      String truth, BuildContext context
      ) {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return CardDialog(claim, url, url1,
              truth
          );
        },
        fullscreenDialog: true
    ));
  }
  // startSearch(String query) async {
  //   if (query.length == 0) {
  //     setState(() {
  //       queryResults = [];
  //       tempStorage = [];
  //     });
  //   }
  //   if(query.length == 1){
  //     List<QueryDocumentSnapshot> qds = await SearchService().searchSingle(query);
  //     qds.forEach((element) {
  //       tempStorage.add(element);
  //     });
  //   }
  //   else{
  //     List<QueryDocumentSnapshot> qds = await SearchService().searchCompound(query,tempStorage);
  //     qds.forEach((element) {
  //       tempStorage.add(element);
  //     });
  //   }
  // }

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
                'Search',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        backgroundColor: Colors.white,
        body: Stack(
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
                    onChanged: (value) async{
                      if (value.length == 0) {
                        setState(() {
                          tempStorage.clear();
                        });
                      }
                      else{
                        setState(() {
                          tempStorage = [];
                          queryResults.forEach((element) {
                            if(element['news'].toString().toLowerCase().contains(value.toLowerCase())){
                              tempStorage.add(element);
                            }
                          });
                        });
                      }
                    },
                    decoration: InputDecoration(
                        hintText: 'Search Here',
                        hintStyle: TextStyle(fontSize: 20),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: Globals.getWidth(20), vertical: Globals.getHeight(15)),
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
                child:
                tempStorage.length!=0?
                ListView(
                  children: List.generate(tempStorage.length, (index) {
                    return GestureDetector(
                      onTap: (){
                        _openAddEntryDialog(tempStorage[index]['news'], tempStorage[index]['url2'], tempStorage[index]['url1'], tempStorage[index]['truth'], context);
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
                                        image: NetworkImage(tempStorage[index]['url2']))),
                              ),
                            ),
                            Positioned(
                              left: Globals.width * (80 / 375),
                              top: Globals.height * (22 / 812),
                              child: Container(
                                width: Globals.width * (260 / 375),
                                child: AutoSizeText(
                                  tempStorage[index]['news'],
                                  style: GoogleFonts.montserrat(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w300),
                                  minFontSize: 15.0,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Positioned(
                              right: Globals.width * (10 / 375),
                              top: Globals.height * (12 / 812),
                              child: Container(
                                  width: Globals.width * (16 / 375),
                                  child: IconButton(
                                    iconSize: 24,
                                    icon: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.grey,
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ):
                Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Image.asset(Images.no_data,height: 250,width: 250,),
                  Text('No Data',style: GoogleFonts.montserrat(fontSize: 30),)
                ],
              ),),
              ),
            )
          ],
        ));
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
                  image: DecorationImage(
                      image: NetworkImage(this.widget.url), fit: BoxFit.cover),
                ),
              ),
            ),
            Positioned(
              top: Globals.height * 0.56,
              left: Globals.width * 0.12,
              child: Container(
                height: Globals.height * 0.25,
                width: Globals.width * 0.8,
                child: AutoSizeText('Source: ' + this.widget.url1.toString()),
              ),
            ),
            Positioned(
              top: Globals.height * 0.65,
              left: Globals.width * 0.1,
              child: Container(
                padding: EdgeInsets.all(10.0),
                height: Globals.height * 0.15,
                width: Globals.width * 0.8,
                child: Center(
                  child: Text(this.widget.truth,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                ),
                decoration: BoxDecoration(
                    color: Color(0xFFEDF2F4),
                    border: Border.all(color: Colors.green, width: 2.0),
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
