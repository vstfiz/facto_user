import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {
  Future<List<QueryDocumentSnapshot>> searchSingle(String query) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('feeds')
        .get();
    List<QueryDocumentSnapshot> ds = querySnapshot.docs;
    ds.clear();

    querySnapshot.docs.forEach((element) {
      if(element['news'].toString().toLowerCase().contains(query.toLowerCase())){
        ds.add(element);
        // print(element.data());
      }
    });
    print('totl reslt ' + ds.length.toString());
    return ds;
  }
}
