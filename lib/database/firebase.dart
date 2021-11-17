import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facto_user/model/ad.dart';
import 'package:facto_user/model/categories.dart';
import 'package:facto_user/model/feed.dart';
import 'package:facto_user/model/search_results.dart';
import 'package:facto_user/model/user.dart';
import 'package:facto_user/util/globals.dart';
import 'package:flutter/cupertino.dart';

class FirebaseDB {
  static Future<bool> getUserDetails(String uid, BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('factoUsers');
    QuerySnapshot querySnapshot = await ref.where('uid', isEqualTo: uid).get();
    List<DocumentSnapshot> ds = querySnapshot.docs;
    if (ds.length == 0) {
      return true;
    } else {
      Globals.user = new User(ds.single['dp'], ds.single['name'], uid,
          ds.single['email'], ds.single['phone']);
      return false;
    }
  }

  static Future<void> createUser(String uid, String email, String dp,
      String name, String phone, BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('factoUsers');
    QuerySnapshot querySnapshot = await ref.where('uid', isEqualTo: uid).get();
    List<DocumentSnapshot> ds = querySnapshot.docs;
    print(uid);
    if (ds.length == 0) {
      await ref.add({
        'uid': uid,
        'email': email,
        'dp': dp,
        'name': name,
        'phone': phone,
      });
    } else {
      await ref.doc(ds.single.id).update({
        'uid': uid,
        'email': email,
        'dp': dp,
        'name': name,
        'phone': phone,
      });
    }
  }

  static Future<List<Feed>> getFeeds(
      bool language, BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var value = List.filled(0, Feed('', '', '', '', ''), growable: true);
    var ref = firestore.collection('feeds');
    if (Globals.feedType) {
      QuerySnapshot querySnapshot;
      if (Globals.category == null) {
        querySnapshot = await ref
            .where('status', isEqualTo: 'True')
            .where('geo', isEqualTo: Globals.location)
            .where('feedType', isEqualTo: Globals.feedType)
            .where('language', isEqualTo: language ? 'English' : 'Hindi')
            .limit(5)
            .get();
      } else {
        querySnapshot = await ref
            .where('status', isEqualTo: 'True')
            .where('geo', isEqualTo: Globals.location)
            .where('feedType', isEqualTo: Globals.feedType)
            .where('language', isEqualTo: language ? 'English' : 'Hindi')
            .where('category', isEqualTo: Globals.category)
            .limit(5)
            .get();
      }
      List<DocumentSnapshot> ds = querySnapshot.docs;
      Globals.lastPostId = ds.last;
      ds.forEach((element) async {
        value.add(new Feed(element['url2'], element['news'], element['truth'],
            element['url1'], element.id));
      });
      ds.forEach((element) async {
        await updateImpressions(element.id);
      });
      Globals.currentFeed = value.first;
      return value;
    } else {
      QuerySnapshot querySnapshot = await ref
          .where('status', isEqualTo: 'True')
          .where('feedType', isEqualTo: false)
          .limit(5)
          .get();
      List<DocumentSnapshot> ds = querySnapshot.docs;
      print('no of cideo posts' + ds.length.toString());
      Globals.lastPostId = ds.last;
      ds.forEach((element) async {
        value.add(new Feed.video(element['url1'], element['news'],
            element['url2'], element['truth']));
      });
      ds.forEach((element) async {
        await updateImpressions(element.id);
      });
      Globals.currentFeed = value.first;
      return value;
    }
  }

  static Future<List<Feed>> getFeedsPage(
      bool language, BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var value = List.filled(0, Feed('', '', '', '', ''), growable: true);
    var ref = firestore.collection('feeds');

    if (Globals.feedType) {
      QuerySnapshot querySnapshot;
      if (Globals.category == null) {
        querySnapshot = await ref
            .where('status', isEqualTo: 'True')
            .where('feedType', isEqualTo: Globals.feedType)
            .where('language', isEqualTo: language ? 'English' : 'Hindi')
            .startAfterDocument(Globals.lastPostId)
            .limit(5)
            .get();
      } else {
        querySnapshot = await ref
            .where('status', isEqualTo: 'True')
            .where('category', isEqualTo: Globals.category)
            .where('feedType', isEqualTo: Globals.feedType)
            .where('language', isEqualTo: language ? 'English' : 'Hindi')
            .startAfterDocument(Globals.lastPostId)
            .limit(5)
            .get();
      }
      List<DocumentSnapshot> ds = querySnapshot.docs;
      ds.forEach((element) async {
        value.add(new Feed(element['url2'], element['news'], element['truth'],
            element['url1'], element.id));
      });
      ds.forEach((element) async {
        await updateImpressions(element.id);
      });
      return value;
    } else {
      QuerySnapshot querySnapshot = await ref
          .where('status', isEqualTo: 'True')
          .where('feedType', isEqualTo: Globals.feedType)
          .startAfterDocument(Globals.lastPostId)
          .limit(5)
          .get();
      List<DocumentSnapshot> ds = querySnapshot.docs;
      ds.forEach((element) async {
        value.add(new Feed.video(element['url1'], element['news'],
            element['url2'], element['truth']));
      });
      ds.forEach((element) async {
        await updateImpressions(element.id);
      });
      return value;
    }
  }

  static Future<void> feedCloner() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('feeds');
    QuerySnapshot querySnapshot =
        await ref.where('feedType', isEqualTo: true).get();
    var ds = querySnapshot.docs.first.data();
    print(querySnapshot.docs.first.data().toString());
    for (int i = 0; i < 25; i++) {
      print('datat adddddd 1');
      await ref.add(ds);
    }
  }

  static Future<Ad> getAd(BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var value = List.filled(0, Ad('', ''), growable: true);
    var ref = firestore.collection('ads');
    QuerySnapshot querySnapshot = await ref.get();
    List<DocumentSnapshot> ds = querySnapshot.docs;
    ds.forEach((element) {
      value.add(new Ad(element['url'], element['value']));
    });
    Random r = new Random();
    int k = r.nextInt(value.length - 1);
    return value[k];
  }

  static Future<void> createClaim(
      description, url1, url2, url, claim, BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('claims');
    await ref.add({
      'category': '',
      'claimId': Globals.getRandString(15),
      'comment': '',
      'description': description,
      'feedType': true,
      'language': 'English',
      'requestedBy': Globals.user.name,
      'requestedByUid': Globals.user.uid,
      'news': claim,
      'url1': url1,
      'url2': url,
      'factCheck': '',
      'status': 'Pending',
      'time': DateTime.now().day.toString() +
          "/" +
          DateTime.now().month.toString() +
          "/" +
          DateTime.now().year.toString(),
    });
  }

  static Future<List<Categories>> getCategories() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var value = List.filled(
        0,
        Categories(
          '',
          '',
        ),
        growable: true);
    var ref = firestore.collection('category');
    QuerySnapshot querySnapshot = await ref.get();
    List<DocumentSnapshot> ds = querySnapshot.docs;
    ds.forEach((element) {
      value.add(new Categories(element['name'], element['url']));
    });
    return value;
  }

  static Future<List<Feed>> getTrending(
      bool language, BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var value = List.filled(0, Feed('', '', '', '', ''), growable: true);
    var ref = firestore.collection('feeds');
    QuerySnapshot querySnapshot = await ref
        .where('status', isEqualTo: 'True')
        .where('feedType', isEqualTo: true)
        .where('language', isEqualTo: language ? 'English' : 'Hindi')
        .orderBy('clicks', descending: true)
        .limit(10)
        .get();
    List<DocumentSnapshot> ds = querySnapshot.docs;
    Globals.lastPostId = ds.last;
    ds.forEach((element) async {
      value.add(new Feed(element['url2'], element['news'], element['truth'],
          element['url1'], element.id));
    });
    return value;
  }

  static Future<List<Feed>> getRecentChecks(language) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var value = List.filled(0, Feed('', '', '', '', ''), growable: true);
    var ref = firestore.collection('feeds');
    QuerySnapshot querySnapshot = await ref
        .where('status', isEqualTo: 'True')
        .where('feedType', isEqualTo: true)
        .where('language', isEqualTo: language ? 'English' : 'Hindi')
        .orderBy('time', descending: true)
        .limit(10)
        .get();
    List<DocumentSnapshot> ds = querySnapshot.docs;
    Globals.lastPostId = ds.last;
    ds.forEach((element) async {
      value.add(new Feed(element['url2'], element['news'], element['truth'],
          element['url1'], element.id));
    });
    return value;
  }

  static Future<List<int>> getCompletedCount() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('claims');
    var val = [0, 0];
    QuerySnapshot querySnapshot = await ref
        .where('requestedByUid', isEqualTo: Globals.user.uid)
        .where('status', isEqualTo: 'True')
        .get();
    val[0] = querySnapshot.docs.length;
    querySnapshot = await ref
        .where('requestedByUid', isEqualTo: Globals.user.uid)
        .where('status', isEqualTo: 'Rejected')
        .get();
    val[1] = querySnapshot.docs.length;
    return val;
  }

  static Future<int> getInProgress() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('claims');
    var count = 0;
    QuerySnapshot querySnapshot = await ref
        .where('requestedByUid', isEqualTo: Globals.user.uid)
        .where('status', isEqualTo: 'Pending')
        .get();
    count = querySnapshot.docs.length;
    return count;
  }

  static Future<void> updateImpressions(String claimId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('feeds');
    DocumentSnapshot ds = await ref.doc(claimId).get();
    int previous = ds['impressions'];
    await ref.doc(claimId).update({'impressions': previous + 1});
  }

  static Future<void> updateClicks(String claimId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('feeds');
    DocumentSnapshot ds = await ref.doc(claimId).get();
    int previous = ds['clicks'];
    await ref.doc(claimId).update({'clicks': previous + 1});
  }

  static Future<List<SearchResults>> getFilteredRequests(String status) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('claims');
    print('sdfcse' + status);
    var data = List.filled(
        0,
        new SearchResults.fromJson({
          'news': '',
          'claimId': '',
          'requestedByUid': '',
          'url2': '',
          'status': '',
        }),
        growable: true);
    switch (status) {
      case 'Pending':
        {
          print('case' + status);
          QuerySnapshot querySnapshot = await ref
              .where('status', isEqualTo: 'Pending')
              .where('requestedByUid', isEqualTo: Globals.user.uid)
              .get();
          List<DocumentSnapshot> ds = querySnapshot.docs;
          ds.forEach((element) {
            print(element);
            data.add(new SearchResults.fromJson(element.data()));
          });
          return data;
        }
        break;
      case 'Rejected':
        {
          print('case' + status);
          QuerySnapshot querySnapshot = await ref
              .where('status', isEqualTo: 'Rejected')
              .where('requestedByUid', isEqualTo: Globals.user.uid)
              .get();
          List<DocumentSnapshot> ds = querySnapshot.docs;
          ds.forEach((element) {
            data.add(new SearchResults.fromJson(element.data()));
          });
          return data;
        }
        break;
      case 'Completed':
        {
          print('case' + status);
          QuerySnapshot querySnapshot = await ref
              .where('status', isEqualTo: 'Rejected')
              .where('requestedByUid', isEqualTo: Globals.user.uid)
              .get();
          List<DocumentSnapshot> ds = querySnapshot.docs;
          ds.forEach((element) {
            data.add(new SearchResults.fromJson(element.data()));
          });
          querySnapshot = await ref
              .where('status', isEqualTo: 'True')
              .where('requestedByUid', isEqualTo: Globals.user.uid)
              .get();
          ds = querySnapshot.docs;
          ds.forEach((element) {
            data.add(new SearchResults.fromJson(element.data()));
          });
          return data;
        }
        break;
      case 'Total':
        {
          print('case' + status);
          QuerySnapshot querySnapshot = await ref
              .where('requestedByUid', isEqualTo: Globals.user.uid)
              .get();
          List<DocumentSnapshot> ds = querySnapshot.docs;
          print(ds.length);
          ds.forEach((element) {
            print(element.data());
            data.add(new SearchResults.fromJson(element.data()));
          });
        }
        break;
    }
    return data;
  }
}
