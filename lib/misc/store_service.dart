import 'package:cloud_firestore/cloud_firestore.dart';

class StoreServices {
  CollectionReference vendors =
      FirebaseFirestore.instance.collection('vendors');

  getTopPickedStore() {
    return vendors
        .where('accVerified', isEqualTo: true)
        .where('isTopPicked', isEqualTo: true)
        .where('shopOpen', isEqualTo: true)
        .orderBy('shopname')
        .snapshots();
  }

  getMeatStore() {
    return vendors
        .where('accVerified', isEqualTo: true)
        .where('shopOpen', isEqualTo: true)
        .orderBy('shopCategory')
        .orderBy('shopname')
        .snapshots();
  }

  getNearByStore() {
    return vendors
        .where('accVerified', isEqualTo: true)
        .where('shopOpen', isEqualTo: true)
        .orderBy('shopname')
        .snapshots();
  }

  getNearByStorePagination() {
    return vendors
        .where('accVerified', isEqualTo: true)
        .orderBy('shopname');
  }


  Future<DocumentSnapshot>getShopDetails(sellerUid) async {
    DocumentSnapshot snapshot = await vendors.doc(sellerUid).get();
    return snapshot;
  }
}
