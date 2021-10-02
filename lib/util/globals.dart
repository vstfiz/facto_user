library Globals;

import 'dart:convert';
import 'dart:math';

import 'package:facto_user/model/feed.dart';
import 'package:facto_user/model/user.dart';
import 'package:facto_user/view/dashboard/dashboard.dart';
import 'package:facto_user/view/explore/explore.dart';
import 'package:facto_user/view/file_claim/file_claim.dart';
import 'package:facto_user/view/search/search.dart';
import 'package:facto_user/view/user_profile/user_profile.dart';
import 'package:flutter/cupertino.dart';

class Globals{
  static double height;
  static double width;
  static double getHeight(double value){
    return (value/1013.3333333333334) * height;
  }
  static double getWidth(double value){
    return (value/480) * width;


  }

  static String getRandString(int len) {
    var random = Random.secure();
    var values = List<int>.generate(len, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }

  static PageController pageController = new PageController(initialPage: 2);
  static var screens = [Search(),FileClaim(),DashBoard(),UserProfile()];
  static int currentTab = 2;

  static bool language = true;
  static User user;
  static String category;
  static bool resendStatus = false;
  static var lastPostId;
  static String url = 'https://firebasestorage.googleapis.com/v0/b/facto-adc57.appspot.com/o/images%2Fout0KpqNduxhEgo9TtCL?alt=media&token=bcdd04e5-9e3b-4766-932f-47ba54b79926';
  static bool feedType = true;
  static Feed currentFeed;
}