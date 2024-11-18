import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class CouponProvider with ChangeNotifier {
  late bool expired;
  late DocumentSnapshot document;
  int discountRate = 0;

  getCouponDetails(title, sellerUid) async {
    DocumentSnapshot document =
        await FirebaseFirestore.instance.collection('coupons').doc(title).get();
    if (document.exists) {
      this.document = document;
      notifyListeners();
      if (document['sellerUid'] == sellerUid) {
        checkExpiry(document);
      }
    }
  }

  checkExpiry(DocumentSnapshot document) {
    DateTime date = document['expiry'].toDate();
    var dateDiff = date.difference(DateTime.now()).inDays;
    if (dateDiff < 0) {
      //Coupon expired
      this.expired = true;
      notifyListeners();
    } else {
      this.document = document;
      this.expired = false;
      this.discountRate = document['discountRate'];
      notifyListeners();
    }
  }
}
